from .schemas import ZStruct
from .utils.list_utils import create_row_vector


def init_Zs(z, n, m):
    # matlab [2:n, n]
    xForw = create_row_vector(1, n-1, post=n-1)
    # matlab [1,1:( n-1)]
    xBack = create_row_vector(0, n-2, pre=0)
    # matlab [2:m, m]
    yForw = create_row_vector(1, m-1, post=m-1)
    # matlab [1,1: (m-1)]
    yBack = create_row_vector(0, m-2, pre=0)

    zs = []
    zs.append(ZStruct(z=z[xForw]))
    zs.append(ZStruct(z=z[xForw][yForw]))
    zs.append(ZStruct(z=z[:][yForw]))
    zs.append(ZStruct(z=z[xBack][yForw]))
    zs.append(ZStruct(z=z[xBack]))
    zs.append(ZStruct(z=z[xBack][yBack]))
    zs.append(ZStruct(z=z[:][yBack]))
    zs.append(ZStruct(z=z[xForw][yBack]))
    zs.append(ZStruct(z=z[xForw]))
    return zs
