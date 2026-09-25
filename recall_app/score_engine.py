# import math
# from django.utils import timezone


# def calculate_retention(
#     understanding,
#     number_of_reviews,
#     last_reviewed
# ):

#     H = 1.5 * 2* understanding - 1

#     review_factor = math.log(1 + number_of_reviews)

#     H_final = H * (1 + 0.2 * review_factor)

#     t = (
#         timezone.now() - last_reviewed
#     ).total_seconds() / 86400

#     retention = math.exp(
#         -(math.log(2) / H_final) * t
#     )

#     return retention, H_final



# import math


# def calculate_recommendation(
#     current_understanding,
#     average_understanding,
#     number_of_reviews,
#     days_since_last_review
# ):
#     # -----------------------------------
#     # 1. Adjusted understanding
#     # -----------------------------------
#     if current_understanding == 0:
#         adjusted_understanding == average_understanding
#     adjusted_understanding = (
#         number_of_reviews * average_understanding
#         + current_understanding
#     ) / (number_of_reviews + 1)

#     # -----------------------------------
#     # 2. Base retention
#     # -----------------------------------

#     base_retention = (
#         adjusted_understanding - 1
#     ) / 9

#     base_retention = max(
#         0.01,
#         min(base_retention, 1.0)
#     )

#     # -----------------------------------
#     # 3. Review stability
#     # -----------------------------------

#     stability = (
#         number_of_reviews
#         / (number_of_reviews + 5)
#     )

#     # -----------------------------------
#     # 4. Effective half-life
#     # -----------------------------------

#     half_life = (
#         1
#         + 14 * base_retention * (1 + stability)
#     )

#     # -----------------------------------
#     # 5. Retention after time decay
#     # -----------------------------------

#     retention = base_retention ** (
#         days_since_last_review / half_life
#     )

#     # -----------------------------------
#     # 6. Understanding gap
#     # -----------------------------------

#     understanding_score = (
#         adjusted_understanding - 1
#     ) / 9

#     understanding_gap = 1 - understanding_score

#     # -----------------------------------
#     # 7. Forgetting risk
#     # -----------------------------------

#     forgetting_risk = 1 - retention

#     # -----------------------------------
#     # 8. Overall priority
#     # -----------------------------------

#     priority = (
#         0.6 * understanding_gap
#         + 0.4 * forgetting_risk
#     )

#     # -----------------------------------
#     # 9. Recommendation
#     # -----------------------------------

#     if adjusted_understanding < 5:
#         recommendation = "REVIEW - improve understanding"

#     elif retention < 0.30:
#         recommendation = "REVIEW - retention is low"

#     else:
#         recommendation = "NOT RECOMMENDED"

#     return {
#         "adjusted_understanding": adjusted_understanding,
#         "retention": retention,
#         "stability": stability,
#         "half_life": half_life,
#         "understanding_gap": understanding_gap,
#         "forgetting_risk": forgetting_risk,
#         "priority": priority,
#         "recommendation": recommendation
#     }


# # -----------------------------------
# # Example
# # -----------------------------------

# # result = calculate_recommendation(
# #     average_understanding=8,
# #     current_understanding=0,  #one entry per day
# #     number_of_reviews=6, 
# #     days_since_last_review=50  #calculate recomm   #put current date into system
# # )

# # for key, value in result.items():

# #     if isinstance(value, float):
# #         print(f"{key}: {value:.4f}")

# #     else:
# #         print(f"{key}: {value}")

def calculate_recommendation(
    current_understanding,
    average_understanding,
    number_of_reviews,
    days_since_last_review
):
    
    current_understanding = current_understanding * 2
    average_understanding = average_understanding * 2
    # -----------------------------------
    # 1. Adjusted understanding
    # -----------------------------------
    if current_understanding == 0:
        adjusted_understanding = average_understanding
    else:
        adjusted_understanding = (
            number_of_reviews * average_understanding
            + current_understanding
        ) / (number_of_reviews + 1)

    # -----------------------------------
    # 2. Base retention
    # -----------------------------------
    base_retention = (
        adjusted_understanding - 1
    ) / 9

    base_retention = max(
        0.01,
        min(base_retention, 1.0)
    )

    # -----------------------------------
    # 3. Review stability
    # -----------------------------------
    stability = (
        number_of_reviews
        / (number_of_reviews + 5)
    )

    # -----------------------------------
    # 4. Effective half-life
    # -----------------------------------
    half_life = (
        1
        + 14 * base_retention * (1 + stability)
    )

    # -----------------------------------
    # 5. Retention after time decay
    # -----------------------------------
    retention = base_retention ** (
        days_since_last_review / half_life
    )

    # -----------------------------------
    # 6. Understanding gap
    # -----------------------------------
    understanding_score = (
        adjusted_understanding - 1
    ) / 9

    understanding_gap = 1 - understanding_score

    # -----------------------------------
    # 7. Forgetting risk
    # -----------------------------------
    forgetting_risk = 1 - retention

    # -----------------------------------
    # 8. Overall priority
    # -----------------------------------
    priority = (
        0.6 * understanding_gap
        + 0.4 * forgetting_risk
    )

    # -----------------------------------
    # 9. Recommendation
    # -----------------------------------
    if adjusted_understanding < 4:
        recommendation = "REVIEW - improve understanding"

    elif retention < 0.3:
        recommendation = "REVIEW - retention is low"

    else:
        recommendation = "NOT RECOMMENDED"

    return {
        "adjusted_understanding": adjusted_understanding,
        "retention": retention,
        "stability": stability,
        "half_life": half_life,
        "understanding_gap": understanding_gap,
        "forgetting_risk": forgetting_risk,
        "priority": priority,
        "recommendation": recommendation,
    }