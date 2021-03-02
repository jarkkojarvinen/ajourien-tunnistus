import pytest
import numpy as np
from src.utils.list_utils import create_row_vector


def test_create_row_vector_with_pre():
    expected = [1, 1, 2, 3, 4, 5]
    result = create_row_vector(1, 5, pre=1)
    assert np.array_equal(expected, result)


def test_create_row_vector_with_post():
    expected = [1, 2, 3, 4, 5, 5]
    result = create_row_vector(1, 5, post=5)
    assert np.array_equal(expected, result)
