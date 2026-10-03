import math

# ---------------------------------------------------------------
# Scale + tuning constants
# ---------------------------------------------------------------
MIN_SCORE = 1                 # understanding is rated 1-5
MAX_SCORE = 5
RETENTION_THRESHOLD = 0.3     # below this a problem needs review
LOW_UNDERSTANDING = 1 / 3     # normalised; same cut-off as the old "< 4 out of 10" (= 2.33 on 1-5)
MAX_BASE_RETENTION = 0.99     # keeps a perfect score decaying (needed to compute a due date)


def normalise(score):
    """Map a 1-5 understanding score onto 0-1."""
    return (score - MIN_SCORE) / (MAX_SCORE - MIN_SCORE)


def project_retention(base_retention, half_life, days):
    """Retention after `days` (same formula as step 5, reusable for projections)."""
    return base_retention ** (days / half_life)


def calculate_recommendation(
    current_understanding,
    average_understanding,
    number_of_reviews,
    days_since_last_review,
):
    # 1. Adjusted understanding (1-5)
    if current_understanding == 0:
        adjusted_understanding = average_understanding
    else:
        adjusted_understanding = (
            number_of_reviews * average_understanding + current_understanding
        ) / (number_of_reviews + 1)

    # 2. Base retention (0-1, from the 1-5 scale)
    understanding_score = max(0.0, min(normalise(adjusted_understanding), 1.0))
    base_retention = max(0.01, min(understanding_score, MAX_BASE_RETENTION))

    # 3. Review stability
    stability = number_of_reviews / (number_of_reviews + 5)

    # 4. Effective half-life
    #    (days for retention to fall to base_retention; kept under its original name)
    half_life = 1 + 14 * base_retention * (1 + stability)

    # 5. Retention after time decay
    retention = project_retention(base_retention, half_life, days_since_last_review)

    # 6-7. Gap and forgetting risk
    understanding_gap = 1 - understanding_score
    forgetting_risk = 1 - retention

    # 8. Overall priority
    priority = 0.6 * understanding_gap + 0.4 * forgetting_risk

    # 9. Recommendation
    if understanding_score < LOW_UNDERSTANDING:
        reason = "understanding"
        recommendation = "REVIEW - improve understanding"
    elif retention < RETENTION_THRESHOLD:
        reason = "retention"
        recommendation = "REVIEW - retention is low"
    else:
        reason = "ok"
        recommendation = "NOT RECOMMENDED"

    # 10. Due date: days until retention crosses the threshold (<= 0 means due now)
    days_to_threshold = half_life * math.log(RETENTION_THRESHOLD) / math.log(base_retention)
    days_until_due = days_to_threshold - days_since_last_review
    if reason == "understanding":
        days_until_due = min(days_until_due, 0.0)

    return {
        "adjusted_understanding": adjusted_understanding,
        "base_retention": base_retention,
        "retention": retention,
        "stability": stability,
        "half_life": half_life,
        "understanding_gap": understanding_gap,
        "forgetting_risk": forgetting_risk,
        "priority": priority,
        "recommendation": recommendation,
        "reason": reason,
        "days_until_due": days_until_due,
    }