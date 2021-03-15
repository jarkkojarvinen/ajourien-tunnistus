import numpy as np
from .schemas.zstruct import ZStruct
from .utils.list_utils import create_row_vector


def init_Zs(z):
    n, m = np.shape(z)
    xForw, xBack, yForw, yBack = __create_index_vectors(n, m)

    return [
        ZStruct(z[xForw]),
        ZStruct(z[xForw][:, yForw]),
        ZStruct(z[:, yForw]),
        ZStruct(z[xBack][:, yForw]),
        ZStruct(z[xBack]),
        ZStruct(z[xBack][:, yBack]),
        ZStruct(z[:, yBack]),
        ZStruct(z[xForw][:, yBack]),
        ZStruct(z[xForw])
    ]


def __create_index_vectors(n, m):
    # matlab [2:n, n]
    xForw = create_row_vector(1, n-1, post=n-1)
    # matlab [1,1:( n-1)]
    xBack = create_row_vector(0, n-2, pre=0)
    # matlab [2:m, m]
    yForw = create_row_vector(1, m-1, post=m-1)
    # matlab [1,1: (m-1)]
    yBack = create_row_vector(0, m-2, pre=0)
    return xForw, xBack, yForw, yBack
