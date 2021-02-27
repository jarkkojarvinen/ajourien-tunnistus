""" 
Curvature computations on a regular grid with a grid constant _delta_.   
ptn 03.06.2018
"""
import math,numpy as np
import matplotlib.pyplot as pl

def getKappas(zss,d):
    """ Returns principla curvatures kappa1,kappa2. """

    sz= zss.shape
    xLeft,xMid,xRight= range(0,sz[0]-2),range(1,sz[0]-1),range(2,sz[0])
    yLeft,yMid,yRight= range(0,sz[1]-2),range(1,sz[1]-1),range(2,sz[1])

    # betas
    betaXss,betaYss= np.zeros(sz),np.zeros(sz)

    betaYss[0   ,:]= np.atan((zss(1     ,:) - zss(0,:))/d)    - 0.0
    betaYss[xMid,:]= np.atan((zss(xRight,:) - zss(xMid,:))/d) - np.atan((zss(xMid,:) - zss(xLeft,:))/d)
    betaYss[-1  ,:]= 0.0                                      - np.atan((zss(-1,:  ) - zss(-2   ,:))/d)

    betaXss[:,0   ]= np.atan((zss(:,1     ) - zss(:,0   ))/d) - 0.0
    betaXss[:,yMid]= np.atan((zss(:,yRight) - zss(:,yMid))/d) - np.atan((zss(:,yMid) - zss(:,yLeft))/d)
    betaXss[:,-1  ]= 0.0                                      - np.atan((zss(:,-1  ) - zss(:    ,-2))/d)

	# lengths
	sz1= sz-1
	lxss,lyss= np.zeros((sz[0],)),np.zeros((sz[1],))
	lxss[:-1]= np.sqrt((zss[1:,:] - zss[:-1,:])**2 + d**2)
	lyss[:-1]= np.sqrt((zss[:,1:] - zss[:,:-1])**2 + d**2)
	lxss[-1],lyss[-1]= lxss[-2],lyss[-2]

    # areas
    Ass= np.zeros(sz)
    endsx,endsy= [0,sz[0]],[0,sz[1]]
    for i in endsx:
        for j in endsy:
            Ass[i,j]=  lxss[i,i]*lyss[i,j]
    Ass[xMid ,endsy]=(lxss[xMid ,endsy] + lxss[xLeft,endsy])*lyss[xMid,endsy]
    Ass[xMid ,yMid ]=(lxss[xMid ,yMid ] + lxss[xLeft,xMid ])*(lyss[xMid,yMid] + lyss[xMid,xLeft])
    Ass[endsx,yMid ]= lxss[endsx,yMid ]*(lyss[endsx,yMid] + lyss[endsx,xLeft])
    Ass/= 4.0

	Gss= betaXss*betaYss/Ass
	
	

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