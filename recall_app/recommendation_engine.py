from django.db.models import Avg
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

    # One query for every average (was one query per problem)
    history_averages = dict(
        ReviewHistory.objects
        .filter(problem_review__user=user)
        .order_by()
        .values_list("problem_review_id")
        .annotate(avg=Avg("understanding"))
    )

    now = timezone.now()
    recommendations = []

    for pr in problem_reviews:
        current_understanding = pr.understanding
        average_understanding = history_averages.get(pr.pk, pr.understanding)

        days_since_last_review = 0.0
        if pr.last_reviewed:
            days_since_last_review = max(
                0.0, (now - pr.last_reviewed).total_seconds() / 86400
            )

        result = calculate_recommendation(
            current_understanding=current_understanding,
            average_understanding=average_understanding,
            number_of_reviews=pr.number_of_reviews,
            days_since_last_review=days_since_last_review,
        )

        pr.average_understanding = average_understanding
        pr.current_understanding = current_understanding
        pr.days_since_last_review = days_since_last_review
        for key, value in result.items():
            setattr(pr, key, value)

        recommendations.append(pr)

    recommendations.sort(key=lambda x: x.priority, reverse=True)
    return recommendations