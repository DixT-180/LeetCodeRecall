import math

# -----------------------------------
# Settings
# -----------------------------------
MIN_UNDERSTANDING = 1
MAX_UNDERSTANDING = 5            # your input scale is 1-5

RETENTION_THRESHOLD = 0.3        # below this a problem is "due"
MAX_DUE_DAYS = 365               # cap for problems that never decay
MAX_BASE_RETENTION = 0.9         # even a perfect 5 should slowly fade
LOW_UNDERSTANDING = 2.5          # below this -> "improve understanding"


def days_until_threshold(base_retention, half_life):
    """Days after the last review until retention drops to the threshold."""
    if base_retention >= 1.0:
        return MAX_DUE_DAYS
    t = half_life * math.log(RETENTION_THRESHOLD) / math.log(base_retention)
    return min(t, MAX_DUE_DAYS)


def calculate_recommendation(
    current_understanding,
    average_understanding,
    number_of_reviews,
    days_since_last_review
):
    span = MAX_UNDERSTANDING - MIN_UNDERSTANDING   # 4 for a 1-5 scale

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
    # 2. Base retention (capped so a perfect score still decays)
    # -----------------------------------
    base_retention = (adjusted_understanding - MIN_UNDERSTANDING) / span
    base_retention = max(0.01, min(base_retention, MAX_BASE_RETENTION))

    # -----------------------------------
    # 3. Review stability
    # -----------------------------------
    stability = number_of_reviews / (number_of_reviews + 5)

    # -----------------------------------
    # 4. Effective half-life
    # -----------------------------------
    half_life = 1 + 14 * base_retention * (1 + stability)

    # -----------------------------------
    # 5. Retention after time decay
    # -----------------------------------
    retention = base_retention ** (days_since_last_review / half_life)

    # -----------------------------------
    # 5b. Days until it is due (negative = overdue)
    # -----------------------------------
    due_in_days = (
        days_until_threshold(base_retention, half_life)
        - days_since_last_review
    )

    # -----------------------------------
    # 6. Understanding gap
    # -----------------------------------
    understanding_score = (adjusted_understanding - MIN_UNDERSTANDING) / span
    understanding_gap = 1 - understanding_score

    # -----------------------------------
    # 7. Forgetting risk
    # -----------------------------------
    forgetting_risk = 1 - retention

    # -----------------------------------
    # 8. Overall priority
    # -----------------------------------
    priority = 0.6 * understanding_gap + 0.4 * forgetting_risk

    # -----------------------------------
    # 9. Recommendation
    # -----------------------------------
    if adjusted_understanding < LOW_UNDERSTANDING:
        recommendation = "REVIEW - improve understanding"
    elif retention < RETENTION_THRESHOLD:
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
        "due_in_days": due_in_days,
    }