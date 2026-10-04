import math
from collections import defaultdict
from datetime import timedelta

from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.utils import timezone
from django.views.decorators.http import require_POST

from .models import Problem, ProblemReview, ReviewHistory, Solution
from .recommendation_engine import get_recommendations
from .score_engine import RETENTION_THRESHOLD, project_retention


# -----------------------------------
# Review settings
# -----------------------------------
# Reviews of the same problem within this window replace each other
# instead of stacking up.
REVIEW_REPLACE_WINDOW = timedelta(hours=24)


# -----------------------------------
# Stats page settings
# -----------------------------------
MASTERED_UNDERSTANDING = 4      # adjusted understanding (1-5)
MASTERED_RETENTION = 0.6        # and still remembered
LOW_RETENTION_PCT = 50          # "low retention" chip = below this
STALE_DAYS = 14                 # "not reviewed in 2+ weeks" chip
SOON_DAYS = 3                   # "due in 3 days" chip
CURVE_DAYS = 30                 # forgetting-curve horizon

REASON_LABELS = {
    "understanding": "Low understanding",
    "retention": "Retention low",
    "ok": "On track",
}


def _parse_understanding(value, default=1):
    """Understanding is rated 1-5. Coerce to int and clamp."""
    try:
        return max(1, min(5, int(value)))
    except (TypeError, ValueError):
        return default


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
            understanding = _parse_understanding(request.POST.get("understanding"))

            # Most recent logged review for this problem (if any)
            latest_history = None
            if review:
                latest_history = (
                    ReviewHistory.objects
                    .filter(problem_review=review)
                    .order_by("-reviewed_at")
                    .first()
                )

            replace_previous = (
                latest_history is not None
                and timezone.now() - latest_history.reviewed_at < REVIEW_REPLACE_WINDOW
            )

            if replace_previous:
                # Same day: overwrite the previous review instead of adding
                # a new one. Review count and history length stay the same.
                latest_history.understanding = understanding
                latest_history.save()

                review.notes = notes
                review.understanding = understanding
                review.last_reviewed = timezone.now()
                review.save()

                messages.info(
                    request,
                    "You already reviewed this within the last 24 hours, "
                    "so your previous review was replaced."
                )

            else:
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
def _span(days):
    days = abs(days)
    if days < 14:
        return f"{round(days)}d"
    if days < 60:
        return f"{round(days / 7)}w"
    if days < 365:
        return f"{round(days / 30)}mo"
    return "1y+"


def _ago(days):
    return "today" if days < 1 else f"{_span(days)} ago"


def _due(days):
    """days <= 0 means due now (overdue, or flagged for low understanding)."""
    if days <= 0:
        n = math.floor(abs(days))
        return "overdue", "Due now" if n == 0 else f"Overdue {_span(n)}"
    if days >= 365:
        return "later", "Not due"
    if days < 1:
        return "soon", "Due today"
    state = "soon" if days <= SOON_DAYS else "later"
    return state, f"In {math.ceil(days)}d"


def _mean(values):
    values = list(values)
    return sum(values) / len(values) if values else 0.0


def _curve(recs):
    """Average retention over the next CURVE_DAYS days if nothing is reviewed."""
    W, H, L, R, T, B = 640, 190, 40, 12, 12, 26
    pw, ph = W - L - R, H - T - B

    def x(t): return L + t / CURVE_DAYS * pw
    def y(v): return T + (1 - v) * ph

    series = [
        _mean(
            project_retention(r.base_retention, r.half_life, r.days_since_last_review + t)
            for r in recs
        )
        for t in range(CURVE_DAYS + 1)
    ]
    line = " ".join(
        f"{'M' if t == 0 else 'L'}{x(t):.1f},{y(v):.1f}" for t, v in enumerate(series)
    )
    area = f"{line} L{x(CURVE_DAYS):.1f},{y(0):.1f} L{x(0):.1f},{y(0):.1f} Z"
    return {
        "path": line,
        "area": area,
        "thr_y": f"{y(RETENTION_THRESHOLD):.1f}",
        "left": L,
        "right": W - R,
        "yticks": [{"y": f"{y(v):.1f}", "label": f"{int(v * 100)}%"} for v in (0, .5, 1)],
        "xticks": [
            {"x": f"{x(t):.1f}", "label": "Today" if t == 0 else f"{t}d"}
            for t in (0, 7, 14, 30)
        ],
        "start_x": f"{x(0):.1f}",
        "start_y": f"{y(series[0]):.1f}",
        "v7": round(series[7] * 100),
        "v14": round(series[14] * 100),
        "v30": round(series[30] * 100),
    }


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
    overdue = due_soon = mastered = low = low_understanding = stale = 0

    for r in recs:
        r.ret_pct = int(r.retention * 100)
        r.ret_class = "r-low" if r.ret_pct < 30 else "r-mid" if r.ret_pct < 60 else "r-high"
        r.since_label = _ago(r.days_since_last_review)
        r.due_in_days = r.days_until_due
        r.due_state, r.due_label = _due(r.due_in_days)
        r.reason_label = REASON_LABELS[r.reason]

        buckets[min(r.ret_pct // 25, 3)]["count"] += 1
        by_cat[r.problem.category].append(r)

        if r.due_state == "overdue":
            overdue += 1
        elif r.due_in_days <= SOON_DAYS:
            due_soon += 1
        if r.ret_pct < LOW_RETENTION_PCT:
            low += 1
        if r.reason == "understanding":
            low_understanding += 1
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
                "overdue": sum(1 for r in items if r.due_state == "overdue"),
                "avg_understanding": _mean(r.adjusted_understanding for r in items),
                "avg_retention_pct": round(_mean(r.retention for r in items) * 100),
            }
            for cat, items in by_cat.items()
        ),
        key=lambda c: (-c["overdue"], c["avg_retention_pct"]),
    )

    context = {
        "recommendations": recs,
        "total_problems": total,
        "total_reviews_logged": ReviewHistory.objects.filter(
            problem_review__user=request.user
        ).count(),
        "avg_understanding": _mean(r.adjusted_understanding for r in recs),
        "avg_memory_span": _mean(r.half_life for r in recs),
        "avg_retention_pct": round(_mean(r.retention for r in recs) * 100),
        "overdue_count": overdue,
        "due_soon_count": due_soon,
        "mastered_count": mastered,
        "low_retention_count": low,
        "low_understanding_count": low_understanding,
        "stale_count": stale,
        "low_cutoff": LOW_RETENTION_PCT - 1,
        "low_cutoff_next": LOW_RETENTION_PCT,
        "review_threshold_pct": round(RETENTION_THRESHOLD * 100),
        "buckets": buckets,
        "category_breakdown": category_breakdown,
        "curve": _curve(recs),
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
        understanding = _parse_understanding(
            request.POST.get("understanding"), default=review.understanding
        )

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