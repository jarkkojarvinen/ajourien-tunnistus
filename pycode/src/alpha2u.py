import numpy as np


def alpha2u(alpha):
    '''
    alpha2u maps a circle perimeter length alpha to a square perimeter length u
    [u,scale]= alpha2u(alpha)
    scale is the length of the mapping shift in case of a unit square
    '''

    c = np.cos(alpha)
    s = np.sin(alpha)
    scale = 1.0 / np.maximum(abs(c), abs(s))
    x = c * scale
    y = s * scale
    eps = 1.0e-8
    if abs(x - 1.0) < eps and 0 <= y:
        u = y
    elif abs(y - 1.0) < eps:
        u = 2 - x
    # x == -1
    elif abs(x + 1.0) < eps:
        u = 4 - y
    # y == -1
    elif abs(y + 1.0) < eps:
        u = 6 + x
    else:
        u = 8 + y

    return u, scale
