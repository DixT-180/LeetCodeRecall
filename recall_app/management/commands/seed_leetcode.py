"""
Management command to seed ONLY the Problem table from LC.docx.

No user, ProblemReview, or Solution rows are touched -- just the
shared catalog of problems (problemid, name, category, description).

Descriptions below are written in my own words (not copied from
recall_app's page text, which is copyrighted) but include the actual
example test cases, since those are just input/output data rather
than protectable prose.

WHERE TO PUT THIS FILE
-----------------------
<your_app>/management/commands/seed_problems.py

HOW TO RUN
-----------------------
python manage.py seed_problems

Idempotent -- safe to re-run; matches on problemid and updates
name/category/description in place rather than duplicating rows.

KNOWN GAPS / OPEN ITEMS
-----------------------------------------------------------
- 90001 has been REMAPPED to the real LeetCode ID 643 (Maximum Average
  Subarray I) -- it's mechanically the same fixed-window problem as
  your "max sum subarray of size k" notes (sum vs. average is just a
  division by k), so it now has a proper detailed description +
  examples like everything else.
- 90002 ("Subarrays with Target Sum") is STILL a synthetic ID and left
  with its short description only, per your instruction to leave
  non-official problems as-is. It doesn't have a clean official
  LeetCode match -- the closest, 560 (Subarray Sum Equals K), allows
  negative numbers and needs a different algorithm (prefix sum +
  hashmap) than the positive-only sliding window in your notes. Still
  waiting on you to say whether to drop it, use 560 anyway with a
  caveat, or swap in a different real ID.
- "Find the Smallest Divisor Given a Threshold" was only a bare link in
  the doc (no problem statement copied in) and was skipped entirely.
"""

from django.core.management.base import BaseCommand

from recall_app.models import Problem


PROBLEMS = [
    {
        "problemid": 3,
        "name": "Longest Substring Without Repeating Characters",
        "category": "SlideWin",
        "description": (
            "Given a string s, find the length of the longest contiguous "
            "substring that contains no repeating characters. A "
            "substring must be made of consecutive characters (unlike a "
            "subsequence, which can skip characters).\n\n"
            "Example 1: s = \"abcabcbb\" -> 3, from the substring \"abc\".\n"
            "Example 2: s = \"bbbbb\" -> 1, from the substring \"b\".\n"
            "Example 3: s = \"pwwkew\" -> 3, from the substring \"wke\" "
            "(note \"pwke\" is a subsequence, not a substring, so it "
            "doesn't count).\n\n"
            "Constraints: 0 <= s.length <= 5 * 10^4; s consists of "
            "English letters, digits, symbols and spaces."
        ),
    },
    {
        "problemid": 15,
        "name": "3Sum",
        "category": "TwoPtr",
        "description": (
            "Given an integer array nums, find all unique triplets of "
            "indices i, j, k (all different from each other) such that "
            "nums[i] + nums[j] + nums[k] == 0. The result must not "
            "contain duplicate triplets (same three values, regardless "
            "of order).\n\n"
            "Example 1: nums = [-1,0,1,2,-1,-4] -> "
            "[[-1,-1,2],[-1,0,1]].\n"
            "Example 2: nums = [0,1,1] -> [] (no triplet sums to zero).\n"
            "Example 3: nums = [0,0,0] -> [[0,0,0]].\n\n"
            "Constraints: 3 <= nums.length <= 3000; "
            "-10^5 <= nums[i] <= 10^5."
        ),
    },
    {
        "problemid": 20,
        "name": "Valid Parentheses",
        "category": "Stack",
        "description": (
            "Given a string containing only the characters "
            "'(', ')', '{', '}', '[' and ']', determine whether it is "
            "valid: every opening bracket must be closed by the same "
            "type of bracket, and brackets must close in the correct "
            "nested order.\n\n"
            "Example 1: s = \"()\" -> true.\n"
            "Example 2: s = \"()[]{}\" -> true.\n"
            "Example 3: s = \"(]\" -> false (wrong bracket type closes "
            "it).\n"
            "Example 4: s = \"([)]\" -> false (closed out of order).\n"
            "Example 5: s = \"{[]}\" -> true.\n\n"
            "Constraints: 1 <= s.length <= 10^4; s consists only of the "
            "six bracket characters."
        ),
    },
    {
        "problemid": 33,
        "name": "Search in Rotated Sorted Array",
        "category": "BinSearch",
        "description": (
            "An array of distinct integers, originally sorted in "
            "ascending order, has been rotated at some unknown pivot. "
            "Given the rotated array and a target value, return the "
            "index of the target, or -1 if it isn't present. Must run "
            "in O(log n) time.\n\n"
            "Example 1: nums = [4,5,6,7,0,1,2], target = 0 -> 4.\n"
            "Example 2: nums = [4,5,6,7,0,1,2], target = 3 -> -1.\n"
            "Example 3: nums = [1], target = 0 -> -1.\n\n"
            "Constraints: 1 <= nums.length <= 5000; all values distinct; "
            "the array is guaranteed to be a rotation of some sorted "
            "array."
        ),
    },
    {
        "problemid": 34,
        "name": "Find First and Last Position of Element in Sorted Array",
        "category": "BinSearch",
        "description": (
            "Given an array sorted in non-decreasing order, find the "
            "starting and ending index of a given target value. Return "
            "[-1, -1] if the target isn't found. Must run in O(log n) "
            "time.\n\n"
            "Example 1: nums = [5,7,7,8,8,10], target = 8 -> [3,4].\n"
            "Example 2: nums = [5,7,7,8,8,10], target = 6 -> [-1,-1].\n"
            "Example 3: nums = [], target = 0 -> [-1,-1].\n\n"
            "Constraints: 0 <= nums.length <= 10^5; "
            "-10^9 <= nums[i], target <= 10^9."
        ),
    },
    {
        "problemid": 35,
        "name": "Search Insert Position",
        "category": "BinSearch",
        "description": (
            "Given a sorted array of distinct integers and a target "
            "value, return the index of the target if found; otherwise "
            "return the index where it would be inserted to keep the "
            "array sorted. Must run in O(log n) time.\n\n"
            "Example 1: nums = [1,3,5,6], target = 5 -> 2.\n"
            "Example 2: nums = [1,3,5,6], target = 2 -> 1.\n"
            "Example 3: nums = [1,3,5,6], target = 7 -> 4.\n"
            "Example 4: nums = [1,3,5,6], target = 0 -> 0.\n\n"
            "Constraints: 1 <= nums.length <= 10^4; "
            "-10^4 <= nums[i], target <= 10^4; nums sorted and distinct."
        ),
    },
    {
        "problemid": 49,
        "name": "Group Anagrams",
        "category": "Hashing",
        "description": (
            "Given an array of strings, group the strings that are "
            "anagrams of one another. The groups can be returned in any "
            "order.\n\n"
            "Example 1: strs = [\"eat\",\"tea\",\"tan\",\"ate\",\"nat\","
            "\"bat\"] -> [[\"bat\"],[\"nat\",\"tan\"],"
            "[\"ate\",\"eat\",\"tea\"]].\n"
            "Example 2: strs = [\"\"] -> [[\"\"]].\n"
            "Example 3: strs = [\"a\"] -> [[\"a\"]].\n\n"
            "Constraints: 1 <= strs.length <= 10^4; each string has "
            "0 to 100 lowercase English letters."
        ),
    },
    {
        "problemid": 69,
        "name": "Sqrt(x)",
        "category": "BinSearch",
        "description": (
            "Given a non-negative integer x, return the square root of "
            "x rounded down to the nearest integer, without using any "
            "built-in exponent or sqrt function.\n\n"
            "Example 1: x = 4 -> 2.\n"
            "Example 2: x = 8 -> 2 (since sqrt(8) is about 2.828, "
            "rounded down).\n\n"
            "Constraints: 0 <= x <= 2^31 - 1."
        ),
    },
    {
        "problemid": 121,
        "name": "Best Time to Buy and Sell Stock",
        "category": "TwoPtr",
        "description": (
            "Given an array where prices[i] is the stock price on day "
            "i, choose a single day to buy and a later day to sell to "
            "maximize profit. Return 0 if no profit is possible.\n\n"
            "Example 1: prices = [7,1,5,3,6,4] -> 5 (buy at 1, sell at "
            "6).\n"
            "Example 2: prices = [7,6,4,3,1] -> 0 (prices only fall, so "
            "no profit is achievable).\n\n"
            "Constraints: 1 <= prices.length <= 10^5; "
            "0 <= prices[i] <= 10^4."
        ),
    },
    {
        "problemid": 150,
        "name": "Evaluate Reverse Polish Notation",
        "category": "Stack",
        "description": (
            "Evaluate an arithmetic expression given as a list of "
            "tokens in Reverse Polish (postfix) notation. Valid "
            "operators are +, -, *, and / (division truncates toward "
            "zero).\n\n"
            "Example 1: tokens = [\"2\",\"1\",\"+\",\"3\",\"*\"] -> 9, "
            "since (2 + 1) * 3 = 9.\n"
            "Example 2: tokens = [\"4\",\"13\",\"5\",\"/\",\"+\"] -> 6, "
            "since 4 + (13 / 5) = 6 with integer division.\n"
            "Example 3: tokens = [\"10\",\"6\",\"9\",\"3\",\"+\",\"-11\","
            "\"*\",\"/\",\"*\",\"17\",\"+\",\"5\",\"+\"] -> 22.\n\n"
            "Constraints: 1 <= tokens.length <= 10^4; each token is "
            "either an operator or an integer."
        ),
    },
    {
        "problemid": 153,
        "name": "Find Minimum in Rotated Sorted Array",
        "category": "BinSearch",
        "description": (
            "An array of unique elements, originally sorted ascending, "
            "has been rotated between 1 and n times. Given the rotated "
            "array, find its minimum element in O(log n) time.\n\n"
            "Example 1: nums = [3,4,5,1,2] -> 1 (original array "
            "[1,2,3,4,5] rotated 3 times).\n"
            "Example 2: nums = [4,5,6,7,0,1,2] -> 0.\n"
            "Example 3: nums = [11,13,15,17] -> 11 (a full rotation "
            "back to the original order).\n\n"
            "Constraints: 1 <= nums.length <= 5000; all values unique."
        ),
    },
    {
        "problemid": 155,
        "name": "Min Stack",
        "category": "Stack",
        "description": (
            "Design a stack that supports push, pop, top, and "
            "retrieving the minimum element, all in O(1) time.\n\n"
            "Example sequence of operations: push(-2), push(0), "
            "push(-3), getMin() -> -3, pop(), top() -> 0, "
            "getMin() -> -2.\n\n"
            "Constraints: values fit in a 32-bit signed integer; "
            "methods are only called on a non-empty stack."
        ),
    },
    {
        "problemid": 162,
        "name": "Find Peak Element",
        "category": "BinSearch",
        "description": (
            "A peak element is one strictly greater than its "
            "neighbors. Given a 0-indexed array (imagine the elements "
            "just outside either end are -infinity), find the index of "
            "any peak in O(log n) time. If multiple peaks exist, any "
            "valid index is accepted.\n\n"
            "Example 1: nums = [1,2,3,1] -> 2 (value 3 is the peak).\n"
            "Example 2: nums = [1,2,1,3,5,6,4] -> 1 or 5 (both 2 and 6 "
            "are valid peaks).\n\n"
            "Constraints: 1 <= nums.length <= 1000; adjacent elements "
            "are never equal."
        ),
    },
    {
        "problemid": 167,
        "name": "Two Sum II - Input Array Is Sorted",
        "category": "TwoPtr",
        "description": (
            "Given a 1-indexed array already sorted in non-decreasing "
            "order, find two numbers that add up to a target and return "
            "their 1-indexed positions. Exactly one solution is "
            "guaranteed to exist.\n\n"
            "Example 1: numbers = [2,7,11,15], target = 9 -> [1,2].\n"
            "Example 2: numbers = [2,3,4], target = 6 -> [1,3].\n"
            "Example 3: numbers = [-1,0], target = -1 -> [1,2].\n\n"
            "Constraints: 2 <= numbers.length <= 3 * 10^4; numbers "
            "sorted in non-decreasing order."
        ),
    },
    {
        "problemid": 238,
        "name": "Product of Array Except Self",
        "category": "Array",
        "description": (
            "Given an integer array nums, return an array where each "
            "element is the product of all the other elements, without "
            "using division and in O(n) time. Any prefix or suffix "
            "product is guaranteed to fit in a 32-bit integer.\n\n"
            "Example 1: nums = [1,2,3,4] -> [24,12,8,6].\n"
            "Example 2: nums = [-1,1,0,-3,3] -> [0,0,9,0,0].\n\n"
            "Constraints: 2 <= nums.length <= 10^5; "
            "-30 <= nums[i] <= 30."
        ),
    },
    {
        "problemid": 347,
        "name": "Top K Frequent Elements",
        "category": "Hashing",
        "description": (
            "Given an integer array and an integer k, return the k "
            "most frequent elements. The answer can be returned in any "
            "order.\n\n"
            "Example 1: nums = [1,1,1,2,2,3], k = 2 -> [1,2].\n"
            "Example 2: nums = [1], k = 1 -> [1].\n\n"
            "Constraints: 1 <= nums.length <= 10^5; "
            "k is guaranteed to be no larger than the number of "
            "distinct elements."
        ),
    },
    {
        "problemid": 367,
        "name": "Valid Perfect Square",
        "category": "BinSearch",
        "description": (
            "Given a positive integer num, determine whether it is a "
            "perfect square (the product of some integer with itself), "
            "without using any built-in sqrt function.\n\n"
            "Example 1: num = 16 -> true (4 * 4 = 16).\n"
            "Example 2: num = 14 -> false (3.742... is not an "
            "integer).\n\n"
            "Constraints: 1 <= num <= 2^31 - 1."
        ),
    },
    {
        "problemid": 496,
        "name": "Next Greater Element I",
        "category": "Stack",
        "description": (
            "nums1 is a subset of nums2 (no duplicates in either). For "
            "each value in nums1, find the first element in nums2 that "
            "is greater and appears to its right; return -1 if none "
            "exists.\n\n"
            "Example 1: nums1 = [4,1,2], nums2 = [1,3,4,2] -> "
            "[-1,3,-1].\n"
            "Example 2: nums1 = [2,4], nums2 = [1,2,3,4] -> [3,-1].\n\n"
            "Constraints: 1 <= nums1.length <= nums2.length <= 1000; "
            "all integers in nums2 are unique."
        ),
    },
    {
        "problemid": 503,
        "name": "Next Greater Element II",
        "category": "Stack",
        "description": (
            "Given a circular integer array (the element after the "
            "last one wraps back to the first), return the next "
            "greater number for every element, searching circularly if "
            "needed. Return -1 for an element with no greater number "
            "anywhere in the array.\n\n"
            "Example 1: nums = [1,2,1] -> [2,-1,2] (the second 1 wraps "
            "around and also finds 2 as its next greater number).\n"
            "Example 2: nums = [1,2,3,4,3] -> [2,3,4,-1,4].\n\n"
            "Constraints: 1 <= nums.length <= 10^4; "
            "-10^9 <= nums[i] <= 10^9."
        ),
    },
    {
        "problemid": 567,
        "name": "Permutation in String",
        "category": "SlideWin",
        "description": (
            "Given two strings s1 and s2, determine whether s2 contains "
            "a contiguous substring that is a permutation (i.e. an "
            "anagram) of s1.\n\n"
            "Example 1: s1 = \"ab\", s2 = \"eidbaooo\" -> true, because "
            "s2 contains \"ba\", a permutation of \"ab\".\n"
            "Example 2: s1 = \"ab\", s2 = \"eidboaoo\" -> false.\n\n"
            "Constraints: 1 <= s1.length, s2.length <= 10^4; both "
            "strings are lowercase English letters."
        ),
    },
    {
        "problemid": 643,
        "name": "Maximum Average Subarray I",
        "category": "SlideWin",
        "description": (
            "Given an integer array nums and an integer k, find a "
            "contiguous subarray of exactly length k that has the "
            "maximum average value, and return that average. (Since k "
            "is fixed, this is the same as finding the subarray of "
            "length k with the maximum sum, then dividing by k.)\n\n"
            "Example 1: nums = [1,12,-5,-6,50,3], k = 4 -> 12.75, from "
            "the subarray [12,-5,-6,50] (sum 51 / 4).\n"
            "Example 2: nums = [5], k = 1 -> 5.0.\n\n"
            "Constraints: 1 <= k <= nums.length <= 10^5; "
            "-10^4 <= nums[i] <= 10^4."
        ),
    },
    {
        "problemid": 704,
        "name": "Binary Search",
        "category": "BinSearch",
        "description": (
            "Given a sorted array of distinct integers and a target "
            "value, return the target's index, or -1 if it isn't "
            "present. Must run in O(log n) time.\n\n"
            "Example 1: nums = [-1,0,3,5,9,12], target = 9 -> 4.\n"
            "Example 2: nums = [-1,0,3,5,9,12], target = 2 -> -1.\n\n"
            "Constraints: 1 <= nums.length <= 10^4; "
            "-10^4 < nums[i], target < 10^4; nums sorted ascending, "
            "all values distinct."
        ),
    },
    {
        "problemid": 739,
        "name": "Daily Temperatures",
        "category": "Stack",
        "description": (
            "Given a list of daily temperatures, return an array where "
            "each position holds the number of days you'd have to wait "
            "for a warmer temperature; use 0 if there is no future day "
            "with a warmer temperature.\n\n"
            "Example: temperatures = [73,74,75,71,69,72,76,73] -> "
            "[1,1,4,2,1,1,0,0].\n\n"
            "Constraints: 1 <= temperatures.length <= 10^5; "
            "30 <= temperatures[i] <= 100."
        ),
    },
    {
        "problemid": 744,
        "name": "Find Smallest Letter Greater Than Target",
        "category": "BinSearch",
        "description": (
            "Given a sorted (non-decreasing) array of characters and a "
            "target character, return the smallest character in the "
            "array that is lexicographically greater than the target. "
            "If none exists, wrap around and return the first "
            "character in the array. There are guaranteed to be at "
            "least two distinct characters in the array.\n\n"
            "Example 1: letters = [\"c\",\"f\",\"j\"], target = \"a\" "
            "-> \"c\".\n"
            "Example 2: letters = [\"c\",\"f\",\"j\"], target = \"c\" "
            "-> \"f\".\n"
            "Example 3: letters = [\"x\",\"x\",\"y\",\"y\"], "
            "target = \"z\" -> \"x\" (wraps around since nothing in "
            "the array is greater than 'z').\n\n"
            "Constraints: 2 <= letters.length <= 10^4; letters sorted "
            "in non-decreasing order."
        ),
    },
    {
        "problemid": 852,
        "name": "Peak Index in a Mountain Array",
        "category": "BinSearch",
        "description": (
            "Given a 'mountain' array (strictly increasing up to a "
            "peak, then strictly decreasing), return the index of the "
            "peak element in O(log n) time.\n\n"
            "Example 1: arr = [0,1,0] -> 1.\n"
            "Example 2: arr = [0,2,1,0] -> 1.\n"
            "Example 3: arr = [0,10,5,2] -> 1.\n\n"
            "Constraints: 3 <= arr.length <= 10^5; the array is "
            "guaranteed to form a valid mountain shape."
        ),
    },
    {
        "problemid": 875,
        "name": "Koko Eating Bananas",
        "category": "BinSearch",
        "description": (
            "Koko has n piles of bananas and h hours before the guards "
            "return. Each hour she picks one pile and eats up to k "
            "bananas from it (finishing the pile early if it has fewer "
            "than k left, and not eating from another pile that same "
            "hour). Find the minimum integer eating speed k that lets "
            "her finish every pile within h hours.\n\n"
            "Example 1: piles = [3,6,7,11], h = 8 -> 4.\n"
            "Example 2: piles = [30,11,23,4,20], h = 5 -> 30.\n"
            "Example 3: piles = [30,11,23,4,20], h = 6 -> 23.\n\n"
            "Constraints: 1 <= piles.length <= 10^4; "
            "piles.length <= h <= 10^9; 1 <= piles[i] <= 10^9."
        ),
    },
    {
        "problemid": 1011,
        "name": "Capacity To Ship Packages Within D Days",
        "category": "BinSearch",
        "description": (
            "Packages (given as a list of weights, in the order they "
            "must be loaded) need to ship within a given number of "
            "days. Each day the ship is loaded with as many packages as "
            "fit without exceeding its weight capacity, in order (no "
            "reordering or splitting a package across days). Find the "
            "minimum ship capacity that still finishes shipping within "
            "the given number of days.\n\n"
            "Example 1: weights = [1,2,3,4,5,6,7,8,9,10], days = 5 -> "
            "15 (day 1: 1,2,3,4,5; day 2: 6,7; day 3: 8; day 4: 9; "
            "day 5: 10).\n"
            "Example 2: weights = [3,2,2,4,1,4], days = 3 -> 6.\n"
            "Example 3: weights = [1,2,3,1,1], days = 4 -> 3.\n\n"
            "Constraints: 1 <= days <= weights.length <= 5*10^4; "
            "1 <= weights[i] <= 500."
        ),
    },
    {
        "problemid": 1652,
        "name": "Defuse the Bomb",
        "category": "Array",
        "description": (
            "Given a circular array 'code' and an integer k, replace "
            "each element with the sum of the next k elements (wrapping "
            "around the array) if k is positive, the sum of the "
            "previous |k| elements if k is negative, or 0 for every "
            "position if k is 0.\n\n"
            "Example 1: code = [5,7,1,4], k = 3 -> [12,10,16,13].\n"
            "Example 2: code = [1,2,3,4], k = 0 -> [0,0,0,0].\n"
            "Example 3: code = [2,4,9,3], k = -2 -> [12,5,6,13].\n\n"
            "Constraints: n == code.length; 1 <= n <= 100; "
            "1 <= code[i] <= 100; -(n - 1) <= k <= n - 1."
        ),
    },

    # ---------------------------------------------------------------
    # Non-official / synthetic entries -- left as-is per instructions,
    # since there's no official LeetCode listing to pull examples from.
    # ---------------------------------------------------------------
    {
        "problemid": 90002,
        "name": "Subarrays with Target Sum",
        "category": "SlideWin",
        "description": (
            "Given an array of positive integers and a target sum, find "
            "every contiguous subarray whose elements add up exactly to "
            "the target."
        ),
    },
]


class Command(BaseCommand):
    help = "Seed only the Problem table from the LC.docx notes (no reviews/solutions)."

    def handle(self, *args, **options):
        created = 0
        updated = 0

        for entry in PROBLEMS:
            _, was_created = Problem.objects.update_or_create(
                problemid=entry["problemid"],
                defaults={
                    "problem_name": entry["name"],
                    "problem_description": entry["description"],
                    "category": entry["category"],
                },
            )
            if was_created:
                created += 1
            else:
                updated += 1

        self.stdout.write(
            self.style.SUCCESS(
                f"Done. Problems created: {created}, updated: {updated}, "
                f"total in list: {len(PROBLEMS)}."
            )
        )