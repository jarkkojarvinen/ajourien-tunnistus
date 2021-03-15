import numpy as np
from .alpha2u import alpha2u


def __calculate_lzb(u, z, zs, h):
    """
    Repeatitive code extracted to single method to return l_x, z_x and beta_x
    """
    uf = int(np.floor(u))
    uc = int(np.ceil(u))
    t = int(u - uf)
    zx = zs[uf].z * (1-t) + zs[uc].z * t
    beta = np.arctan2(zx - z, h)
    lx = h / np.cos(beta)
    return lx, zx, beta


def get_directional_H(alpha, delta, z, zs):
    '''
    Returns the directional curvature and slope
    [H,s]= getDirectionalH(alpha,delta)
    H: curvature, s: slope 
    '''
    u1, h = alpha2u(alpha)
    h = h * delta

    # 1) z(alpha), l(alpha), beta(alpha)
    l1, z1, beta1 = __calculate_lzb(u1, z, zs, h)

    # 2) z(alpha+pi), l(alpha+pi), beta(alpha+pi)
    # +pi in alpha --> +4 in u
    u2 = (u1 + 4) % 8
    l2, z2, beta2 = __calculate_lzb(u2, z, zs, h)

    s = np.abs(z2 - z1) / (2*h)
    # clear z1
    z1 = None
    # clear z2
    z2 = None

    # 3)
    H = -2.0 * (beta1 + beta2) / (l1 + l2)

    return H, s
