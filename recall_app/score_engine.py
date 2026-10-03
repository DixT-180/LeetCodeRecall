import math

RETENTION_THRESHOLD = 0.3
MAX_DUE_DAYS = 365

def days_until_threshold(base_retention, half_life):
    if base_retention >= 1.0:          # understanding 10 never decays
        return MAX_DUE_DAYS
    t = half_life * math.log(RETENTION_THRESHOLD) / math.log(base_retention)
    return min(t, MAX_DUE_DAYS)

def calculate_recommendation(
    current_understanding,
    average_understanding,
    number_of_reviews,
    days_since_last_review
):
    
    # current_understanding = current_understanding * 2
    # average_understanding = average_understanding * 2
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
    due_in_days = days_until_threshold(base_retention, half_life) - days_since_last_review

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