import math
from collections import defaultdict

from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.utils import timezone
from django.views.decorators.http import require_POST

from .models import Problem, ProblemReview, ReviewHistory, Solution
from .recommendation_engine import get_recommendations


# -----------------------------------
# Stats page settings
# -----------------------------------
MASTERED_UNDERSTANDING = 8      # adjusted understanding (1-10)
MASTERED_RETENTION = 0.6        # and still remembered
LOW_RETENTION_PCT = 50          # "low retention" chip = below this
STALE_DAYS = 14                 # "not reviewed in 2+ weeks" chip


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

    query = request.GET.get("q", "").strip()

    problems = Problem.objects.all()

    if query:
        if query.isdigit():
            problems = problems.filter(problemid=query)
        else:
            problems = problems.filter(problem_name__icontains=query)

    problems = problems.order_by("problemid")

    return render(
        request,
        "recall_app/home_problems.html",
        {
            "problems": problems,
            "query": query,
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
                review.last_reviewed = timezone.now()   # restart the due-date clock
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


# -----------------------------------
# Stats
# -----------------------------------
def _ago(days):
    return "today" if days < 1 else f"{int(days)}d ago"


def _due(days):
    if days >= 365:
        return "later", "Not due"
    if days < 0:
        n = math.floor(abs(days))
        return "overdue", "Overdue today" if n == 0 else f"Overdue {n}d"
    if days < 1:
        return "soon", "Due today"
    state = "soon" if days <= 3 else "later"
    return state, f"In {math.ceil(days)}d"


@login_required
def stats(request):
    recs = get_recommendations(request.user)   # already sorted by priority
    total = len(recs)
    if total == 0:
        return render(request, "recall_app/stats.html", {"total_problems": 0})

    buckets = [
        {"lo": 0, "hi": 24, "label": "Under 25%", "cls": "r-low", "count": 0},
        {"lo": 25, "hi": 49, "label": "25–49%", "cls": "r-low", "count": 0},
        {"lo": 50, "hi": 74, "label": "50–74%", "cls": "r-mid", "count": 0},
        {"lo": 75, "hi": 100, "label": "75% and up", "cls": "r-high", "count": 0},
    ]
    by_cat = defaultdict(list)
    overdue = due_soon = mastered = low = stale = 0

    for r in recs:
        r.ret_pct = int(r.retention * 100)
        r.ret_class = "r-low" if r.ret_pct < 30 else "r-mid" if r.ret_pct < 60 else "r-high"
        r.since_label = _ago(r.days_since_last_review)
        r.due_state, r.due_label = _due(r.due_in_days)

        buckets[min(r.ret_pct // 25, 3)]["count"] += 1
        by_cat[r.problem.category].append(r)

        if r.due_in_days < 0:
            overdue += 1
        elif r.due_in_days <= 3:
            due_soon += 1
        if r.ret_pct < LOW_RETENTION_PCT:
            low += 1
        if r.days_since_last_review >= STALE_DAYS:
            stale += 1
        if (r.adjusted_understanding >= MASTERED_UNDERSTANDING
                and r.retention >= MASTERED_RETENTION):
            mastered += 1

    for b in buckets:
        b["share"] = round(b["count"] / total * 100)

    category_breakdown = sorted(
        (
            {
                "category": cat,
                "count": len(items),
                "overdue": sum(1 for r in items if r.due_in_days < 0),
                "avg_understanding": sum(r.adjusted_understanding for r in items) / len(items),
                "avg_retention": sum(r.retention for r in items) / len(items),
            }
            for cat, items in by_cat.items()
        ),
        key=lambda c: -c["count"],
    )

    context = {
        "recommendations": recs,
        "total_problems": total,
        "total_reviews_logged": ReviewHistory.objects.filter(
            problem_review__user=request.user
        ).count(),
        "avg_average_understanding": sum(r.average_understanding for r in recs) / total,
        "avg_half_life": sum(r.half_life for r in recs) / total,
        "avg_retention": sum(r.retention for r in recs) / total,
        "avg_difficulty": sum(r.understanding_gap for r in recs) / total,
        "overdue_count": overdue,
        "due_soon_count": due_soon,
        "mastered_count": mastered,
        "low_retention_count": low,
        "low_cutoff": LOW_RETENTION_PCT - 1,
        "low_cutoff_next": LOW_RETENTION_PCT,
        "stale_count": stale,
        "buckets": buckets,
        "category_breakdown": category_breakdown,
    }
    return render(request, "recall_app/stats.html", context)


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
def edit_solution(request, solution_id):
    solution = get_object_or_404(
        Solution,
        id=solution_id,
        problem_review__user=request.user
    )

    title = request.POST.get("title", "").strip()
    code = request.POST.get("code", "")
    explanation = request.POST.get("explanation", "")

    if not title or not code:
        messages.error(request, "Title and code are required.")
    else:
        solution.title = title
        solution.code = code
        solution.explanation = explanation
        solution.save()
        messages.success(request, "Solution updated.")

    problemid = solution.problem_review.problem.problemid
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


@login_required
def add_problem(request):
    error = None

    if request.method == "POST":
        problem_name = request.POST.get("problem_name", "").strip()
        problemid = request.POST.get("problemid", "").strip()
        category = request.POST.get("category", "").strip()
        problem_description = request.POST.get("problem_description", "").strip()

        if not problem_name or not problemid or not category or not problem_description:
            error = "All fields are required."
        elif not problemid.isdigit():
            error = "Problem ID must be a number."
        elif Problem.objects.filter(problemid=problemid).exists():
            error = f"Problem #{problemid} already exists."
        else:
            Problem.objects.create(
                problem_name=problem_name,
                problemid=problemid,
                category=category,
                problem_description=problem_description,
            )
            messages.success(request, f"Problem #{problemid} - {problem_name} added.")
            return redirect("home_problems")

    return render(
        request,
        "recall_app/add_problem.html",
        {"error": error}
    )


@login_required
def edit_problem(request, problemid):
    problem = get_object_or_404(Problem, problemid=problemid)
    error = None

    if request.method == "POST":
        problem_name = request.POST.get("problem_name", "").strip()
        new_problemid = request.POST.get("problemid", "").strip()
        category = request.POST.get("category", "").strip()
        problem_description = request.POST.get("problem_description", "").strip()

        if not problem_name or not new_problemid or not category or not problem_description:
            error = "All fields are required."
        elif not new_problemid.isdigit():
            error = "Problem ID must be a number."
        elif int(new_problemid) != problem.problemid and Problem.objects.filter(problemid=new_problemid).exists():
            error = f"Problem #{new_problemid} already exists."
        else:
            problem.problem_name = problem_name
            problem.problemid = new_problemid
            problem.category = category
            problem.problem_description = problem_description
            problem.save()
            messages.success(request, f"Problem #{new_problemid} - {problem_name} updated.")
            return redirect("home_problems")

    return render(
        request,
        "recall_app/edit_problem.html",
        {"problem": problem, "error": error}
    )


@login_required
@require_POST
def delete_problem(request, problemid):
    problem = get_object_or_404(Problem, problemid=problemid)
    problem_name = problem.problem_name
    problem.delete()  # cascades: ProblemReview -> ReviewHistory + Solution, for all users
    messages.success(request, f"Problem #{problemid} - {problem_name} deleted.")
    return redirect("home_problems")