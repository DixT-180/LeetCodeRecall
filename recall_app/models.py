from django.db import models
from django.contrib.auth.models import User


class Problem(models.Model):
    problem_name = models.CharField(max_length=255)
    problem_description = models.TextField()
    problemid = models.IntegerField(unique=True)
    category = models.CharField(max_length=10)

    def __str__(self):
        return f"{self.problemid} - {self.problem_name}"


class ProblemReview(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    problem = models.ForeignKey(Problem, on_delete=models.CASCADE)
    notes = models.TextField(blank=True)
    solution = models.TextField(blank=True)
    last_reviewed = models.DateTimeField(auto_now_add=True)
    understanding = models.IntegerField()
    number_of_reviews = models.IntegerField(default=1)
    half_life = models.FloatField(default=0)
    retention = models.FloatField(default=1)
    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=["user", "problem"],
                name="unique_user_problem"
            )
        ]

    def __str__(self):
        return f"{self.user.username} - {self.problem.problemid}"


class ReviewHistory(models.Model):
    problem_review = models.ForeignKey(
        ProblemReview,
        on_delete=models.CASCADE
    )

    understanding = models.IntegerField()
    reviewed_at = models.DateTimeField(auto_now_add=True)

class Solution(models.Model):
    problem_review = models.ForeignKey(
        ProblemReview,
        on_delete=models.CASCADE,
        related_name="solutions"
    )

    title = models.CharField(max_length=255)
    code = models.TextField()
    explanation = models.TextField(blank=True)

    def __str__(self):
        return self.title


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