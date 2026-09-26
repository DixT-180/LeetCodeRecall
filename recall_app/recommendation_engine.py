from django.utils import timezone

from .models import ProblemReview, ReviewHistory
from .score_engine import calculate_recommendation


def get_recommendations(user):

    problem_reviews = (
        ProblemReview.objects
        .filter(user=user)
        .exclude(number_of_reviews=0)
        .select_related("problem")
    )

    now = timezone.now()
    recommendations = []

    for problem_review in problem_reviews:

        histories = (
            ReviewHistory.objects
            .filter(problem_review=problem_review)
            .order_by("reviewed_at")
        )

        if histories.exists():
            history = [(h.reviewed_at, h.understanding) for h in histories]
        else:
            # No ReviewHistory rows logged yet -- fall back to treating
            # the ProblemReview's own record as a single data point.
            history = [(problem_review.last_reviewed, problem_review.understanding)]

        result = calculate_recommendation(history, now)

        for key, value in result.items():
            setattr(problem_review, key, value)

        recommendations.append(problem_review)

    recommendations.sort(key=lambda x: x.priority, reverse=True)

    return recommendations