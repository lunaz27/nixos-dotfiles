import pytest

from sample import bubble_sort


@pytest.mark.parametrize(
    ("input_arr", "expected_out"),
    [
        ([3, 1, 2, 4, 5], [1, 2, 3, 4, 5]),
        ([], []),
        ([1], [1]),
        ([1, 2, 3, 4], [1, 2, 3, 4]),
        ([9, 7, 5, 3], [3, 5, 7, 9]),
        ([-5, 0, 5, -2], [-5, -2, 0, 5]),
        ([555, -222, -111, 444, 333], [-222, -111, 333, 444, 555]),
    ],
    ids=[
        "standard_unsorted",
        "empty_list",
        "single_element",
        "already_sorted",
        "reversed_list",
        "negative_numbers",
        "mixed_signed_numbers",
    ],
)
def test_bubble_sort(input_arr: list[int], expected_out: list[int]) -> None:
    bubble_sort(input_arr)
    assert input_arr == expected_out
