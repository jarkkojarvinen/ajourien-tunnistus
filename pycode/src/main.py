import numpy as np
import scipy.io as sio
from skimage.filters.rank import entropy
from skimage.morphology import disk, square
from progress.bar import Bar
from .initZs import init_Zs
from .getDirectionalH import get_directional_H
from .schemas.datastruct import DataStruct


def run(mat_fname, m=0.03292):
    """
    mat_fname = file path to mat file
    m = grid constant
    """
    print('Reading stuff...')
    temp = sio.loadmat(mat_fname)
    z0 = temp['z'].astype(int)
    sz0 = z0.shape
    mask = temp['mask'].astype(int)
    # Clear temp
    temp = None

    # can be 1,2,4,6,8,... (no odd numbers 3,5,... allowed)
    kSkip = 128
    # (m) grid constant
    delta = kSkip * m

    if kSkip == 1:
        dls = [1, 1]
    else:
        # kSkip has to be odd!
        l = int(kSkip / 2)
        dls = np.array([[0, 0],
                        [l, 0],
                        [0, l],
                        [l, l]])
    nDls = len(dls)

    z = None
    Hfinal = Afinal = sFinal = 0 * z0
    indsXUsed = indsYUsed = []

    with Bar('Processing directional curvatures', max=nDls) as bar:
        for l in range(0, nDls):
            # work amount...
            bar.next()
            dl = dls[l]
            indsLx = np.arange(dl[0], sz0[0], kSkip)
            indsLy = np.arange(dl[1], sz0[1], kSkip)
            z = z0[indsLx][:, indsLy]
            sz = z.shape

            #n, m = np.shape(z)
            zs = init_Zs(z)
            #alphas = np.arange(0.0, 45.0, 15.0)
            alphas = np.arange(0.0, 180.0, 15.0)
            alphas = alphas * np.pi/180.0
            nAlphas = len(alphas)
            data = []

            for k in range(0, nAlphas):
                alpha = alphas[k]
                H, s = get_directional_H(alpha, delta, z, zs)
                entr_img = entropy(H, square(9))  # entropy = entropyfilt(H)
                data.append(DataStruct(H=H, J=entropy, s=s))

            nAll = sz.prod(axis=1)
            with Bar('Assembling an image from entropy minimae', max=nAll*nDls) as subbar:
                Js = np.zeros(nAlphas)
                counter = 0
                dCounter = 100000

                # aspects
                A = 0 * H
                for i in range(0, sz(0)):
                    for j in range(0, sz(1)):
                        if counter % dCounter == 0:
                            subbar.next()
                        counter = counter + 1

                        for k in range(1, nAlphas):
                            Js[k] = data[k].J[i, j]

                        k = min(Js)[1]
                        H[i, j] = data[k].J[i, j]
                        A[i, j] = k
                        s[i, j] = data[k].s[i, j]

                HFinal[indsLx][:, indsLy] = H
                AFinal[indsLx][:, indsLy] = A
                sFinal[indsLx][:, indsLy] = s
                indsXUsed = np.concatenate((indsXUsed, indsLx))
                indsYUsed = np.concatenate((indsYUsed, indsLy))

        indsXUsed = np.sort(np.unique(indsXUsed), axis=0)
        indsYUsed = np.sort(np.unique(indsYUsed), axis=0)
        H = HFinal[indsLx][:, indsLy]
        Hfinal = None
        A = AFinal[indsLx][:, indsLy]
        Afinal = None
        s = sFinal[indsLx][:, indsLy]
        sFinal = None
        #mask = mask(indsXUsed, indsYUsed)
