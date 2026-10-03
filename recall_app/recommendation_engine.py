

from datetime import timedelta

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

    recommendations = []

    for problem_review in problem_reviews:

        histories = ReviewHistory.objects.filter(
            problem_review=problem_review
        )

        # -----------------------------------
        # Average understanding
        # -----------------------------------
        if histories.exists():
            total_understanding = sum(
                history.understanding
                for history in histories
            )

            average_understanding = (
                total_understanding / histories.count()
            )
        else:
            average_understanding = (
                problem_review.understanding
            )

        # -----------------------------------
        # Current understanding
        # -----------------------------------
        current_understanding = (
            problem_review.understanding
        )

        # -----------------------------------
        # Number of reviews
        # -----------------------------------
        number_of_reviews = (
            problem_review.number_of_reviews
        )

        # -----------------------------------
        # Days since last review
        # -----------------------------------
        days_since_last_review = (
            # timezone.now() + timedelta(days=15) - problem_review.last_reviewed
            timezone.now() - problem_review.last_reviewed
        ).total_seconds() / 86400

        # -----------------------------------
        # Calculate recommendation
        # -----------------------------------
        result = calculate_recommendation(
            current_understanding=current_understanding,
            average_understanding=average_understanding,
            number_of_reviews=number_of_reviews,
            days_since_last_review=days_since_last_review,
        )

        # -----------------------------------
        # Add result to ProblemReview object
        # -----------------------------------
        problem_review.average_understanding = (
            average_understanding
        )

        problem_review.current_understanding = (
            current_understanding
        )

        problem_review.days_since_last_review = (
            days_since_last_review
        )

        problem_review.adjusted_understanding = (
            result["adjusted_understanding"]
        )

        problem_review.retention = (
            result["retention"]
        )

        problem_review.stability = (
            result["stability"]
        )

        problem_review.half_life = (
            result["half_life"]
        )

        problem_review.understanding_gap = (
            result["understanding_gap"]
        )

        problem_review.due_in_days = result["due_in_days"]
        problem_review.forgetting_risk = (
            result["forgetting_risk"]
        )

        problem_review.priority = (
            result["priority"]
        )

        problem_review.recommendation = (
            result["recommendation"]
        )

        recommendations.append(problem_review)

    # -----------------------------------
    # Highest priority first
    # -----------------------------------
    recommendations.sort(
        key=lambda x: x.priority,
        reverse=True
    )

    return recommendations
