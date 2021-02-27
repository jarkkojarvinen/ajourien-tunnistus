"""
Computes the histogram of oriented curvatures (HOC) from 
a National Survey of Finland (NSF) DEM file (2 m or 10 m).
ptn 03.06.2018
"""
import sys,os,random,math
from timeit import default_timer as timer
import numpy as np
import fileManager,curvature3

_delta_= 0.0  # (m) grid constant, read from the DEM header

def blurp(msg= None):
    """ Exit with a blurp if something goes wrong... """
    if msg:
        print(msg, file= sys.stderr)
    print('Usage: %s <inputFile>.<type> <delta>} ' % sys.argv[0], file= sys.stderr)
    print('<delta> (int: 2,4,8 or 16 meters). The output grid size', file= sys.stderr)
    print('Reads ../z/<inputFile.asc.', file= sys.stderr)
    print('Writes ../curvatures<delta>/<inputFile>.k[12]', file= sys.stderr)
    sys.exit(0)

if __name__ == "__main__":
    if sys.version_info[0] == 2:
        sys.exit(1) # no python 2.x!

    n= len(sys.argv)
    if n != 3: 
        blurp('Wrong number of args!')
    n= int(sys.argv[2]) # output grid size (in meters)
    if not n in [2,4,8,16]:
        blurp('Wrong value of <delta>', file= sys.stderr)
    else:
        nOrig= n
        n//= 2 # in [1,2,4,8]

    start1= timer()
    fIn= sys.argv[1]
    fOut= os.path.basename(fIn)
    fOut= os.path.splitext(fOut)[0]

    header,zss= fileManager.readMML(fIn)

    # taking sparse samples: _delta_ ==> _delta*n
    if False:
        inds1= np.linspace(0,zss.shape[0], num= zss.shape[0]/n, endpoint= False, dtype=np.int)
        inds2= np.linspace(0,zss.shape[1], num= zss.shape[1]/n, endpoint= False, dtype=np.int)
        zss= (zss[inds1,:].T)[inds2,:].T # zss= zss(inds1,inds2); % matlab expression 
    else:
        zss= zss[0:zss.shape[0]:n,0:zss.shape[1]:n]

    _delta_= header['cellsize']* n

    print('principal curvatures', file=sys.stderr)
    start2= timer()
    kappa1ss,kappa2ss= curvature3.getKappas(zss,_delta_)
    end2= timer()

    print('Computation time %.3f (secs)' % (end2-start2), file= sys.stderr)
    print('saving kappa[12].txt', file=sys.stderr)
    
    np.savetxt(('../c%d/' % nOrig)+ fOut+ '.k1', kappa1ss, delimiter=',')
    np.savetxt(('../c%d/' % nOrig)+ fOut+ '.k2', kappa2ss, delimiter=',')

    end1= timer()        
    print('Total time %.3f (data management added, secs)' % (end1-start1), file= sys.stderr)
