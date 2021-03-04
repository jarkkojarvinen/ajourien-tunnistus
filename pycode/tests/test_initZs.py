import pytest
import numpy as np
from src.initZs import init_Zs, __create_index_vectors


def test_create_index_vectors():
    n = 5
    m = 3

    xForw, xBack, yForw, yBack = __create_index_vectors(n, m)

    expected = [1, 2, 3, 4, 4]
    assert np.array_equal(expected, xForw)

    expected = [0, 0, 1, 2, 3]
    assert np.array_equal(expected, xBack)

    expected = [1, 2, 2]
    assert np.array_equal(expected, yForw)

    expected = [0, 0, 1]
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

    assert np.array_equal(z[xForw][ :   ],  result[0].z)
    assert np.array_equal(z[xForw][yForw],  result[1].z)
    assert np.array_equal(z[ :   ][yForw],  result[2].z)
    assert np.array_equal(z[xBack][yForw],  result[3].z)
    assert np.array_equal(z[xBack][ :   ],  result[4].z)
    assert np.array_equal(z[xBack][yBack],  result[5].z)
    assert np.array_equal(z[ :   ][yBack],  result[6].z)
    assert np.array_equal(z[xForw][yBack],  result[7].z)
    assert np.array_equal(z[xForw][ :   ],  result[8].z)


