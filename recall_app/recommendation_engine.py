

# # from django.utils import timezone

# # from .models import ReviewHistory
# # from .score_engine import calculate_retention


# # def get_recommendations(user):

# #     histories = (
# #         ReviewHistory.objects
# #         .filter(problem_review__user=user)
# #         .select_related("problem_review__problem")
# #         .order_by(
# #             "problem_review__problem",
# #             "reviewed_at"
# #         )
# #     )

# #     # Group reviews by problem
# #     problem_histories = {}

# #     for history in histories:

# #         problem_id = history.problem_review.problem_id

# #         if problem_id not in problem_histories:
# #             problem_histories[problem_id] = []

# #         problem_histories[problem_id].append(history)

# #     recommendations = []

# #     for problem_id, reviews in problem_histories.items():

# #         # For testing, use every review

# #         # Latest review
# #         latest_review = reviews[-1]

# #         # understanding = latest_review.understanding
# #         # number_of_reviews = len(reviews)
# #         # Latest review still drives recency (last_reviewed, review count)
# #         # latest_review = reviews[-1]

# # # Understanding is now the average across every review logged
# # # for this problem, not just the most recent one — a couple of
# # # early low scores still pull the average down even if the
# # # latest attempt went well.
# #         understanding_values = [review.understanding for review in reviews]
# #         understanding = sum(understanding_values) / len(understanding_values)
# #         today = timezone.localdate()

# #         today_reviews = [
# #             review for review in reviews
# #             if timezone.localtime(review.reviewed_at).date() == today
# #         ]

# #         if today_reviews:
# #             curr_understanding = today_reviews[-1].understanding
# #         else:
# #             curr_understanding = 0
# #         number_of_reviews = len(reviews)
# #         # last_reviewed = latest_review.reviewed_at 
# #         last_reviewed = latest_review.reviewed_at - timezone.timedelta(days=60)

# #         retention, half_life = calculate_retention(
# #             curr_understanding,
# #             understanding,
# #             number_of_reviews,
# #             last_reviewed
# #         )

# #         recommendations.append({
# #             "problem": latest_review.problem_review.problem,
# #             "retention": retention,
# #             "half_life": half_life,
# #             "understanding": understanding,
# #             "number_of_reviews": number_of_reviews,
# #             "last_reviewed": last_reviewed,
# #         })

# #     # Lowest retention = higher review priority
# #     recommendations.sort(
# #         key=lambda x: x["retention"]
# #     )

# #     return recommendations


# from django.utils import timezone

# from .models import ProblemReview, ReviewHistory
# from .score_engine import calculate_recommendation
# from datetime import timedelta

# def get_recommendations(user):

#     problem_reviews = (
#         ProblemReview.objects
#         .filter(user=user)
#         .select_related("problem")
#     )

#     recommendations = []

#     for problem_review in problem_reviews:

#         histories = ReviewHistory.objects.filter(
#             problem_review=problem_review
#         )

#         # -----------------------------------
#         # Average understanding
#         # -----------------------------------
#         if histories.exists():
#             total_understanding = sum(
#                 history.understanding
#                 for history in histories
#             )

#             average_understanding = (
#                 total_understanding / histories.count()
#             )
#         else:
#             average_understanding = (
#                 problem_review.understanding
#             )

#         # -----------------------------------
#         # Current understanding
#         # -----------------------------------
#         current_understanding = (
#             problem_review.understanding
#         )

#         # -----------------------------------
#         # Number of reviews
#         # -----------------------------------
#         number_of_reviews = (
#             problem_review.number_of_reviews
#         )

#         # -----------------------------------
#         # Days since last review
#         # -----------------------------------
#         days_since_last_review = (
#             timezone.now() + timedelta(days=15) - problem_review.last_reviewed
#         ).total_seconds() / 86400

#         # -----------------------------------
#         # Calculate recommendation
#         # -----------------------------------
#         result = calculate_recommendation(
#             current_understanding=current_understanding,
#             average_understanding=average_understanding,
#             number_of_reviews=number_of_reviews,
#             days_since_last_review=days_since_last_review,
#         )

#         # -----------------------------------
#         # Add result to ProblemReview object
#         # -----------------------------------
#         problem_review.average_understanding = (
#             average_understanding
#         )

#         problem_review.current_understanding = (
#             current_understanding
#         )

#         problem_review.days_since_last_review = (
#             days_since_last_review
#         )

#         problem_review.adjusted_understanding = (
#             result["adjusted_understanding"]
#         )

#         problem_review.retention = (
#             result["retention"]
#         )

#         problem_review.stability = (
#             result["stability"]
#         )

#         problem_review.half_life = (
#             result["half_life"]
#         )

#         problem_review.understanding_gap = (
#             result["understanding_gap"]
#         )

#         problem_review.forgetting_risk = (
#             result["forgetting_risk"]
#         )

#         problem_review.priority = (
#             result["priority"]
#         )

#         problem_review.recommendation = (
#             result["recommendation"]
#         )

#         recommendations.append(problem_review)

#     # -----------------------------------
#     # Highest priority first
#     # -----------------------------------
#     recommendations.sort(
#         key=lambda x: x.priority,
#         reverse=True
#     )

#     return recommendations

from datetime import timedelta

from django.utils import timezone

from .models import ProblemReview, ReviewHistory
from .score_engine import calculate_recommendation


def get_recommendations(user):

    problem_reviews = (
        ProblemReview.objects
        .filter(user=user)
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
            timezone.now() + timedelta(days=15) - problem_review.last_reviewed
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