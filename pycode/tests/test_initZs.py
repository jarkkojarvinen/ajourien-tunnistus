import pytest
import numpy as np
from src.initZs import init_Zs, __create_index_vectors
from src.utils.list_utils import create_row_vector


def test_create_index_vectors():
    xForw, xBack, yForw, yBack = __create_index_vectors(111, 67)

    # xForw: 1, 2, ..., 110, 110 (1x111)
    expected = create_row_vector(1, 110, post=110)
    assert np.array_equal(expected, xForw)

    # xBack: 0, 0, 1, ..., 109 (1x111)
    expected = create_row_vector(0, 109, pre=0)
    assert np.array_equal(expected, xBack)

    # yForw: 1, 2, ..., 66, 66 (1x67)
    expected = create_row_vector(1, 66, post=66)
    assert np.array_equal(expected, yForw)

    # yBack: 0, 0, 1, ..., 65 (1x67)
    expected = create_row_vector(0, 65, pre=0)
    assert np.array_equal(expected, yBack)


def test_init_Zs():
    z = np.array(
        [[0, 0, 0, 0, 0],
         [1, 1, 1, 1, 1],
         [2, 2, 2, 2, 2],
         [3, 3, 3, 3, 3],
         [4, 4, 4, 4, 4],
         [5, 5, 5, 5, 5]]
    )

    xForw = [1, 2, 3, 4, 5, 5]
    xBack = [0, 0, 1, 2, 3, 4]
    yForw = [1, 2, 3, 4, 4]
    yBack = [0, 0, 1, 2, 3]

    result = init_Zs(z)

    assert np.array_equal(z[xForw],            result[0].z)
    assert np.array_equal(z[xForw][:, yForw],    result[1].z)
    assert np.array_equal(z[:, yForw],           result[2].z)
    assert np.array_equal(z[xBack][:, yForw],    result[3].z)
    assert np.array_equal(z[xBack],            result[4].z)
    assert np.array_equal(z[xBack][:, yBack],    result[5].z)
    assert np.array_equal(z[:, yBack],           result[6].z)
    assert np.array_equal(z[xForw][:, yBack],    result[7].z)
    assert np.array_equal(z[xForw],            result[8].z)
