""" 
Curvature computations on a regular grid with a grid constant _delta_.   
ptn 03.06.2018
"""
import math,numpy as np
import matplotlib.pyplot as pl

def getNormals(zss, d):
    """
    Unit normals of the z raster grid points. 
    Normals are indexed by the first dimension first. 
    """
    
    sz= zss.shape
    xLeft,xMid,xRight= range(0,sz[0]-2),range(1,sz[0]-1),range(2,sz[0])
    yLeft,yMid,yRight= range(0,sz[1]-2),range(1,sz[1]-1),range(2,sz[1])

    nss= np.zeros((sz[0],sz[1],3))
    # 2x,5x,8x
    nss[xMid,:,0]= (zss[xLeft,:]-zss[xRight,:])/2	
    # 4y,5y,6y
    nss[:,yMid,1]= (zss[:,yLeft]-zss[:,yRight])/2

    # 1x,4x,7x
    nss[0,:,0]= zss[0,:]-zss[1,:]

    # 3x,6x,9x
    nss[-1,:,0]= zss[-2,:]-zss[-1,:]

    # 1y,2y,3y 
    nss[:,0,1]= zss[:,0]-zss[:,1]

    # 7y,8,9y
    nss[:,-1,1]= zss[:,-2]-zss[:,-1]

    # to unit normals!
    temp= np.sqrt(nss[:,:,0]**2 + nss[:,:,1]**2 + (d**2))
    for i in range(3):
        nss[:,:,i]= nss[:,:,i]/temp

    return nss

def getU1(alpha):
    """ Returns the perimeter length u in the case of a unit cell """
    s,c= math.sin(alpha),math.cos(alpha)
    if abs(s) <= c:    # quadrant a)  u= 0.0 ... 1.0 
        u= 0.5+ 0.5*s/c
    elif abs(c) <= s:  # quadrant b)  u= 1.0 ... 2.0
        u= 1.5- 0.5*c/s
    elif abs(s) <= -c: # quadrant c)  u= 2.0 ... 3.0 
        u= 2.5+ 0.5*s/c
    else: # abs(c) <= -s: quadrant d) u= 3.0 ... 4.0
        u= 3.5- 0.5*c/s
    u= u % 4.0 # u in [0.0,4.0)
    return u
def getU4(alpha):
    """ Returns the perimeter length u in the case of a 4-cell """
    s,c= math.sin(alpha),math.cos(alpha)
    if abs(s) <= c:    # quadrant a) 
        u= 0.0+ s/c
    elif abs(c) <= s:  # quadrant b) 
        u= 2.0- c/s
    elif abs(s) <= -c: # quadrant c) 
        u= 4.0- s/c
    else: # abs(c) <= -s: quadrant d) 
        u= 6.0+ c/s
    u= u % 8.0 # u in [0.0,8.0)
    return u


def getBeta(n1,n2):
    pass

def getHss(zss,nss, u,alpha):
    return Hss

def getKappas(zss):
    return k1ss,k2ss

def test():
    pass

if __name__ == "__main__":
    test()