import pytest
import numpy as np
#from pytest_mock import MockerFixture
from ..initZs import create_list


def test_create_custom_list_with_pre():
    expected = [0, 0, 1, 2]
    result = create_custom_list(0, 3, pre=0)
    assert np.array_equal(expected, result)

def test_create_custom_list_with_post():
    expected = [0, 1, 2, 2]
    result = create_custom_list(0, 3, post=2)
    assert np.array_equal(expected, result)