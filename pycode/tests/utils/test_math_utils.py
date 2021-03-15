import pytest
import numpy as np
from src.utils.math_utils import histogram


testdata = [
    (
        np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
        5,
        [2, 2, 2, 2, 2],
        [1.9, 3.7, 5.5, 7.3, 9.1]
    ),
    (
        np.array([2, 4, 6, 8, 10, 12, 14, 16, 18, 20]),
        8,
        [2, 1, 1, 1, 1, 1, 1, 2],
        [3.125, 5.375, 7.625, 9.875, 12.125, 14.375, 16.625, 18.875]
    ),
    (
        np.array([11, 14, 15, 19, 10, 29, 34, 12, 42, 12, 15]),
        10,
        [4, 3, 1, 0, 0, 1, 0, 1, 0, 1],
        [11.6, 14.8, 18.0, 21.2, 24.4, 27.6, 30.8, 34.0, 37.2, 40.4]
    )
]


@pytest.mark.parametrize("x,nbins,expected_count,expected_bins", testdata)
def test_histogram(x, nbins, expected_count, expected_bins):
    actual_count, actual_bins = histogram(x, nbins)

    assert np.array_equal(expected_count, actual_count)
    assert np.array_equal(expected_bins, actual_bins)
