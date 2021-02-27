""" 
Concentrated curvature computations on a regular grid with a grid constant _delta_.   
ptn 03.06.2018
"""
import sys,math,numpy as np
import matplotlib.pyplot as plt

def getKappas(zss,d):
    """ Returns principal curvatures kappa1,kappa2. """

    sz= zss.shape
    xLeft,xMid,xRight= range(0,sz[0]-2),range(1,sz[0]-1),range(2,sz[0])
    yLeft,yMid,yRight= range(0,sz[1]-2),range(1,sz[1]-1),range(2,sz[1])

    # betas
    betaXss,betaYss= np.zeros(sz),np.zeros(sz)
    betaYss[xMid,:]= np.arctan((zss[xRight,:] - zss[xMid,:])/d) - np.arctan((zss[xMid,:] - zss[xLeft,:])/d)
    betaXss[:,yMid]= np.arctan((zss[:,yRight] - zss[:,yMid])/d) - np.arctan((zss[:,yMid] - zss[:,yLeft])/d)

    # lengths (will be a divisor)
    lxss,lyss= np.zeros(sz),np.zeros(sz)
    lxss[:-1,:]= np.sqrt((zss[1:,:] - zss[:-1,:])**2 + d**2)
    lyss[:,:-1]= np.sqrt((zss[:,1:] - zss[:,:-1])**2 + d**2)
    lxss[-1,:],lyss[:,-1]= lxss[-2,:],lyss[:,-2]

    # areas (will be a divisor)
    mm,lm,ml,rm,mr= np.ix_(xMid,yMid),np.ix_(xLeft,yMid),np.ix_(xMid,yLeft),np.ix_(xRight,yMid),np.ix_(xMid,yRight)
    Ass= np.zeros(sz)
    Ass[mm]=np.multiply(lxss[mm] + lxss[lm], lyss[mm] + lyss[ml])
    Ass/= 4.0

    Ass[0,:],Ass[-1,:]= Ass[1,:],Ass[-2,:]
    Ass[:,0],Ass[:,-1]= Ass[:,1],Ass[:,-2]

    Gss= np.divide(np.multiply(betaXss,betaYss),Ass)
    Hss= np.zeros(sz)
    Hss[mm]= \
        np.divide(  betaXss[lm]+3*betaXss[mm], lxss[lm]) +\
        np.divide(3*betaXss[mm]+  betaXss[rm], lxss[mm]) +\
        np.divide(  betaYss[ml]+3*betaYss[mm], lyss[ml]) +\
        np.divide(3*betaYss[mm]+  betaXss[mr], lyss[mm])
    Hss/= 2.0

    Hss[0,:],Hss[-1,:]= Hss[1,:],Hss[-2,:]
    Hss[:,0],Hss[:,-1]= Hss[:,1],Hss[:,-2]

    Dss= np.sqrt((Hss**2 - Gss).astype(dtype=complex))
    temp= np.imag(Dss)
    if temp.max() > temp.min():
        n= len(np.where(temp != 0.0))
        print('imaginary values met! \#=%d, %f>%f' % (n, temp.max(),temp.min()), file=sys.stderr)
    temp= []
    Dss= np.real(Dss)

    kappa1ss,kappa2ss= Hss + Dss, Hss - Dss
    if True:
        plt.subplot(221)
        plt.imshow(Hss)
        plt.title('Hss')
        plt.colorbar()
        plt.subplot(222)
        plt.imshow(Gss)
        plt.title('Gss')
        plt.colorbar()

        plt.subplot(223)
        plt.imshow(kappa1ss)
        plt.title('kappa1ss')
        plt.colorbar()
        plt.subplot(224)
        plt.imshow(kappa2ss)
        plt.title('kappa2ss')
        plt.colorbar()
        plt.show()

    return kappa1ss,kappa2ss

def test():
    pass

if __name__ == "__main__":
    test()