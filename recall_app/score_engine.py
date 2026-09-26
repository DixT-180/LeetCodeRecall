"""
Spaced-repetition scoring engine.

Each problem's memory state is modeled the way modern spaced-repetition
schedulers (Anki's FSRS, SuperMemo's SM-17, etc.) do, instead of treating
every review as an independent, order-blind data point:

  - STABILITY: how many days it currently takes for your recall
    probability on this problem to fall to 50% ("half-life" of memory).
    Grows on every successful recall -- more so the longer you'd gone
    without practicing it and still got it right (recalling something
    you were about to forget builds a stronger memory than recalling
    something you'd just seen).

  - DIFFICULTY: a 0 (trivial) to 1 (brutal) running estimate of how hard
    this problem is for you, updated after every review toward how you
    rated that attempt. Harder problems grow stability more slowly per
    success.

  - RETENTION: given STABILITY and days since your last review, this is
    your estimated current recall probability, via the standard
    exponential/power-law forgetting curve:
        retention = 2 ^ (-days_since_review / stability)

Every rating ever logged for a problem (ReviewHistory) is replayed in
order to build STABILITY and DIFFICULTY, so a rough start followed by
solid recent reviews correctly shows as "mostly mastered, don't forget
it yet" rather than being dragged down by a flat average.
"""

import math


# ---------------------------------------------------------------------------
# Tunable constants
# ---------------------------------------------------------------------------

MIN_RATING = 1
MAX_RATING = 5
PASS_THRESHOLD = 3  # rating >= this counts as a successful recall

# Starting stability (days until ~50% retention) after ONE review,
# indexed by that first rating.
INITIAL_STABILITY_DAYS = {
    1: 0.5,
    2: 1.0,
    3: 2.5,
    4: 5.0,
    5: 9.0,
}

# Difficulty (0=easy, 1=hard) each rating pulls the running estimate
# toward. Moves partway there each time rather than snapping.
DIFFICULTY_TARGET = {
    1: 1.0,
    2: 0.8,
    3: 0.55,
    4: 0.3,
    5: 0.1,
}
DIFFICULTY_EMA_WEIGHT = 0.3

GROWTH_BASE = 1.3               # base stability multiplier on success
FAIL_STABILITY_FACTOR = 0.4     # stability collapse factor on failure

MIN_STABILITY_DAYS = 0.5
MAX_STABILITY_DAYS = 3650       # 10 years -- avoid runaway numbers

DUE_RETENTION_TARGET = 0.85     # retention level considered "time to review"

PRIORITY_WEIGHT_FORGETTING = 0.55
PRIORITY_WEIGHT_DIFFICULTY = 0.45


def _clamp(value, low, high):
    return max(low, min(value, high))


def _stability_growth(stability, difficulty, rating, predicted_retention):
    """Multiplier applied to stability after a successful review."""

    rating_factor = 0.6 + 0.2 * rating          # 3->1.2, 4->1.4, 5->1.6
    difficulty_factor = 1.4 - 0.8 * difficulty  # 0->1.4, 1->0.6

    # "Desirable difficulty": recalling something you were close to
    # forgetting builds a stronger memory than recalling something
    # you'd just seen.
    retrievability_bonus = 1 + 1.2 * (1 - predicted_retention)

    growth = GROWTH_BASE * rating_factor * difficulty_factor * retrievability_bonus
    return max(1.05, growth)


def simulate_problem_state(history, now):
    """
    Replays every logged rating for a problem, oldest first, to derive
    its current memory state.

    `history` is a list of (reviewed_at, rating) tuples (ratings on the
    app's 1-5 scale). `now` is a timezone-aware datetime.
    """

    if not history:
        raise ValueError("simulate_problem_state requires at least one rating")

    stability = None
    difficulty = 0.55
    previous_timestamp = None
    ratings_seen = []

    for reviewed_at, rating in history:
        rating = _clamp(rating, MIN_RATING, MAX_RATING)
        ratings_seen.append(rating)

        if stability is None:
            # First ever review of this problem.
            stability = INITIAL_STABILITY_DAYS[rating]
            difficulty = DIFFICULTY_TARGET[rating]
        else:
            elapsed_days = max(
                0.0,
                (reviewed_at - previous_timestamp).total_seconds() / 86400,
            )
            predicted_retention = 2 ** (-elapsed_days / stability)

            if rating >= PASS_THRESHOLD:
                growth = _stability_growth(
                    stability, difficulty, rating, predicted_retention
                )
                stability = stability * growth
            else:
                stability = stability * FAIL_STABILITY_FACTOR * (rating / PASS_THRESHOLD)

            stability = _clamp(stability, MIN_STABILITY_DAYS, MAX_STABILITY_DAYS)

            target_difficulty = DIFFICULTY_TARGET[rating]
            difficulty = difficulty + DIFFICULTY_EMA_WEIGHT * (
                target_difficulty - difficulty
            )
            difficulty = _clamp(difficulty, 0.0, 1.0)

        previous_timestamp = reviewed_at

    last_reviewed = previous_timestamp
    days_since_last_review = max(0.0, (now - last_reviewed).total_seconds() / 86400)
    retention = 2 ** (-days_since_last_review / stability)

    return {
        "stability": stability,
        "difficulty": difficulty,
        "last_reviewed": last_reviewed,
        "days_since_last_review": days_since_last_review,
        "retention": retention,
        "latest_rating": ratings_seen[-1],
        "average_rating": sum(ratings_seen) / len(ratings_seen),
        "review_count": len(ratings_seen),
    }


def calculate_recommendation(history, now):
    """
    Full pipeline: replay history into a memory state, then turn that
    state into the numbers the dashboard displays and sorts by.
    """

    state = simulate_problem_state(history, now)

    stability = state["stability"]
    difficulty = state["difficulty"]
    retention = state["retention"]

    understanding_gap = difficulty       # 0 = mastered, 1 = still shaky
    forgetting_risk = 1 - retention

    priority = (
        PRIORITY_WEIGHT_FORGETTING * forgetting_risk
        + PRIORITY_WEIGHT_DIFFICULTY * understanding_gap
    )

    # Days from *last review* until retention would drop to
    # DUE_RETENTION_TARGET, solved from retention = 2^(-t/stability):
    #   t = -stability * log2(target)
    interval_to_due = -stability * math.log2(DUE_RETENTION_TARGET)
    days_until_due = interval_to_due - state["days_since_last_review"]

    current_understanding = state["latest_rating"]        # 1-5
    average_understanding = state["average_rating"]       # 1-5
    adjusted_understanding = 1 + (1 - difficulty) * 9      # 1-10 (higher = better)

    if difficulty >= 0.7:
        recommendation = "REVIEW - improve understanding"
    elif retention < 0.30:
        recommendation = "REVIEW - retention is low"
    elif days_until_due <= 0:
        recommendation = "DUE SOON"
    else:
        recommendation = "NOT RECOMMENDED"

    return {
        "half_life": stability,
        "stability": stability,
        "difficulty": difficulty,
        "retention": retention,
        "understanding_gap": understanding_gap,
        "forgetting_risk": forgetting_risk,
        "priority": priority,
        "recommendation": recommendation,
        "current_understanding": current_understanding,
        "average_understanding": average_understanding,
        "adjusted_understanding": adjusted_understanding,
        "days_since_last_review": state["days_since_last_review"],
        "last_reviewed": state["last_reviewed"],
        "days_until_due": max(0.0, days_until_due),
        "days_overdue": max(0.0, -days_until_due),
        "number_of_reviews": state["review_count"],
    }