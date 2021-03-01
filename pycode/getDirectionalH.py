import numpy as np
from alpha2u import alpha2u

def get_directional_H(alpha, delta, z, zs):
    '''
    Returns the directional curvature and slope
    [H,s]= getDirectionalH(alpha,delta)
    H: curvature, s: slope 
    '''
    # TODO: Use method on steps 1 and 2
    # def calculate_z_l(_u, _z, _h):
    #     uf = np.floor(_u)
    #     uc = np.ceil(_u)
    #     t = _u - uf
    #     z_1 = zs(uf).z * (1-t) + zs(uc).z * t
    #     beta_1 = np.atan2(z_1 - _z, _h)
    #     l_1 = _h / np.cos(beta_1)
    #     return l_1, z_1


    u1, h = alpha2u(alpha)
    h = h * delta
    
    # 1) z(alpha), l(alpha), beta(alpha)
    # TODO: Call method calculate_z_l
    uf = np.floor(u1)
    uc = np.ceil(u1)
    t = u1 - uf
    z1 = zs(uf).z * (1-t) + zs(uc).z * t
    beta1 = np.atan2(z1 - z, h)
    l1 = h / np.cos(beta1)
    
    # 2) z(alpha+pi), l(alpha+pi), beta(alpha+pi)
    # +pi in alpha --> +4 in u
    u2 = (u1 + 4) % 8
    # TODO: Call method calculate_z_l
    uf = np.floor(u2)
    uc = np.ceil(u2)
    t = u2 - uf    
    z2 = zs(uf).z * (1-t) + zs(uc).z * t
    beta2 = np.atan2(z2 - z, h)
    l2 = h / np.cos(beta2)

    s = np.abs(z2 - z1) / (2*h)
    # clear z1
    z1 = None
    # clear z2
    z2 = None    
    
    # 3)
    H = -2.0 * (beta1 + beta2) / (l1 + l2)

    return H, s