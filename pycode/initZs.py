import numpy as np
from typing import NamedTuple, List
from pydantic import BaseModel

# TODO: Move to proper place
def create_custom_list(start, end, pre=None, post=None):
    """
    TODO: Is this really how it should be?
    a) Let's assume that we have matlab code [2:4, 4]
    Result is [2, 3, 4, 4]
    b) Let's assume that we have matlab code [1, 1:3]
    Result is [1, 1, 2, 3]
    """
    new_list = list([i for i in range(start, end)])
    if pre is not None:
        new_list.insert(0, pre)
    elif post is not None:
        new_list.append(post)
    return np.array(new_list).astype(int)

class ZStruct(NamedTuple):
    """
    Represents Z item on array used in initZs
    """
    z: List[int]


def init_Zs(z, n, m):
    zs = [ZStruct] * 9
    for i in range(0, 9):
        zs[i].z = z
 
    # matlab [2:n, n]
    xForw = create_custom_list(1, n+1, post=n)
    # matlab [1,1:( n-1)]
    xBack = create_custom_list(0, n, pre=0)
    # matlab [2:m, m]
    yForw = create_custom_list(1, m+1, post=m)
    # matlab [1,1: (m-1)]
    yBack = create_custom_list(0, m, pre=0)

    # TODO: Here is some indexing problem
    zs[0].z = z[xForw][:]
    zs[1].z = z[xForw][yForw]
    zs[2].z = z[:][yForw]
    zs[3].z = z[xBack][yForw]
    zs[4].z = z[xBack][:]
    zs[5].z = z[xBack][yBack]
    zs[6].z = z[:][yBack]
    zs[7].z = z[xForw][yBack]
    zs[8].z = z[xForw][:]
 
    return zs
