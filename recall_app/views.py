from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.utils import timezone
from django.views.decorators.http import require_POST

from .models import Problem, ProblemReview, ReviewHistory, Solution
from .recommendation_engine import get_recommendations


def register(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]

        user = User.objects.create_user(
            username=username,
            password=password
        )

        login(request, user)

        return redirect("home")

    return render(request, "recall_app/register.html")


def login_view(request):
    error = None

    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]

        user = authenticate(
            request,
            username=username,
            password=password
        )

        if user is not None:
            login(request, user)
            return redirect("home")

        error = "Incorrect username or password."

    return render(request, "recall_app/login.html", {"error": error})


def logout_view(request):
    logout(request)

    return redirect("login")


@login_required
def problem_list(request):

    problems = Problem.objects.all().order_by("problemid")

    return render(
        request,
        "recall_app/home_problems.html",
        {
            "problems": problems
        }
    )


@login_required
def home(request):

    recommendations = get_recommendations(request.user)

    return render(
        request,
        "recall_app/home.html",
        {
            "recommendations": recommendations
        }
    )


@login_required
def problem_detail(request, problemid):

    problem = get_object_or_404(
        Problem,
        problemid=problemid
    )

    review = ProblemReview.objects.filter(
        user=request.user,
        problem=problem
    ).first()

    if request.method == "POST":

        form_type = request.POST.get("form_type", "review")

        if form_type == "solution":

            # A solution needs a review to hang off of. Create a bare
            # one if the user hasn't reviewed this problem yet.
            if not review:
                review = ProblemReview.objects.create(
                    user=request.user,
                    problem=problem,
                    understanding=1
                )

            title = request.POST.get("title") or "Untitled solution"
            code = request.POST.get("code", "")
            explanation = request.POST.get("explanation", "")

            Solution.objects.create(
                problem_review=review,
                title=title,
                code=code,
                explanation=explanation
            )

            return redirect("problem_detail", problemid=problemid)

        else:
            notes = request.POST["notes"]
            understanding = request.POST["understanding"]

            if review:
                review.notes = notes
                review.understanding = understanding
                review.number_of_reviews += 1
                review.save()

            else:
                review = ProblemReview.objects.create(
                    user=request.user,
                    problem=problem,
                    notes=notes,
                    understanding=understanding
                )

            ReviewHistory.objects.create(
                problem_review=review,
                understanding=understanding
            )

            return redirect("problem_detail", problemid=problemid)

    solutions = review.solutions.all().order_by("-id") if review else []

    return render(
        request,
        "recall_app/problem_detail.html",
        {
            "problem": problem,
            "review": review,
            "solutions": solutions,
        }
    )


@login_required
def delete_solution(request, solution_id):

    solution = get_object_or_404(
        Solution,
        id=solution_id,
        problem_review__user=request.user
    )

    problemid = solution.problem_review.problem.problemid
    solution.delete()

    return redirect("problem_detail", problemid=problemid)


@login_required
@require_POST
def reset_problem_stats(request, problemid):
    """
    Resets a single problem's review stats for the current user back to
    a fresh baseline, and wipes its review history log. Does NOT touch
    notes, saved solutions, or the Problem itself.
    """

    review = get_object_or_404(
        ProblemReview,
        user=request.user,
        problem__problemid=problemid
    )

    problem_name = review.problem.problem_name

    # Wipe the review history log for this problem
    ReviewHistory.objects.filter(problem_review=review).delete()

    # Reset stats. Using .update() (not .save()) so last_reviewed --
    # which is auto_now_add and normally can't be reassigned after
    # creation -- can still be reset to "now".
    ProblemReview.objects.filter(pk=review.pk).update(
        understanding=1,
        number_of_reviews=0,
        half_life=0,
        retention=1,
        last_reviewed=timezone.now(),
    )

    messages.success(
        request,
        f"Stats reset for #{problemid} - {problem_name}."
    )

    return redirect("home")


@login_required
def review_history(request):
    histories = (
        ReviewHistory.objects
        .filter(problem_review__user=request.user)
        .select_related("problem_review__problem")
        .order_by("-reviewed_at"))

    return render(
        request,
        "recall_app/review_history.html",
        {
            "histories": histories
        }
    )


@login_required
def review_problem(request, problemid):

    problem = get_object_or_404(
        Problem,
        problemid=problemid
    )

    review, created = ProblemReview.objects.get_or_create(
        user=request.user,
        problem=problem,
        defaults={"understanding": 1}
    )

    if request.method == "POST":

        notes = request.POST.get("notes")
        understanding = request.POST.get("understanding")

        review.notes = notes
        review.understanding = understanding
        review.save()

        return redirect(
            "review_problem",
            problemid=problemid
        )

    solutions = review.solutions.all().order_by("-id")

    return render(
        request,
        "recall_app/review_problem.html",
        {
            "problem": problem,
            "review": review,
            "solutions": solutions,
        }
    )