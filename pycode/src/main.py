import numpy as np
import scipy.io as sio
from skimage.filters.rank import entropy
from skimage.morphology import square
from tqdm.auto import trange
from .initZs import init_Zs
from .getDirectionalH import get_directional_H
from .schemas.datastruct import DataStruct
from .utils.math_utils import histogram
from .utils.image_utils import (
    create_ks_histograms,
    create_curvature_image,
    create_aspect_index_image,
    create_slope_image)


def run(mat_fname, m=0.03292):
    """
    mat_fname = file path to mat file
    m = grid constant. Default value 0.03292
    """
    print(f'Reading {mat_fname}...')
    temp = sio.loadmat(mat_fname)
    z0 = temp['z'].astype(int)
    sz0 = z0.shape
    mask = temp['mask'].astype(int)
    # Clear temp
    temp = None

    # can be 1,2,4,6,8,... (no odd numbers 3,5,... allowed)
    kSkip = 64
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
    Hfinal = np.zeros(sz0)
    Afinal = np.zeros(sz0)
    sFinal = np.zeros(sz0)
    indsXUsed = []
    indsYUsed = []

    for l in trange(nDls, desc='Processing directional curvatures'):
        dl = dls[l]
        indsLx = np.arange(dl[0], sz0[0], kSkip)
        indsLy = np.arange(dl[1], sz0[1], kSkip)
        z = z0[np.ix_(indsLx, indsLy)]
        sz = z.shape

        zs = init_Zs(z)
        # alphas = np.arange(0.0, 45.0, 15.0) * np.pi/180.0
        # 0, 15, 30, ..., 165
        alphas = np.arange(0.0, 180.0, 15.0) * np.pi/180.0
        nAlphas = len(alphas)
        data = []

        for k in range(0, nAlphas):
            alpha = alphas[k]
            H, s = get_directional_H(alpha, delta, z, zs)
            ent = entropy(H, square(9))
            # H=curvature, J=entropy, s=slope
            data.append(DataStruct(H=H, J=ent, s=s))

        Js = np.zeros(nAlphas)
        # aspects
        A = np.zeros(H.shape)
        for i in trange(sz[0], desc='Assembling an image from entropy minimae'):
            for j in range(0, sz[1]):
                for k in range(0, nAlphas):
                    Js[k] = data[k].J[i, j]

                k = np.min(Js).astype(int)
                H[i, j] = data[k].H[i, j]
                A[i, j] = k
                s[i, j] = data[k].s[i, j]

        Hfinal[np.ix_(indsLx, indsLy)] = H
        Afinal[np.ix_(indsLx, indsLy)] = A
        sFinal[np.ix_(indsLx, indsLy)] = s
        indsXUsed = np.concatenate((indsXUsed, indsLx)).astype(int)
        indsYUsed = np.concatenate((indsYUsed, indsLy)).astype(int)

    indsXUsed = np.sort(np.unique(indsXUsed))
    indsYUsed = np.sort(np.unique(indsYUsed))
    H = Hfinal[np.ix_(indsXUsed, indsYUsed)]
    Hfinal = None
    A = Afinal[np.ix_(indsXUsed, indsYUsed)]
    Afinal = None
    s = sFinal[np.ix_(indsXUsed, indsYUsed)]
    sFinal = None
    mask = mask[np.ix_(indsXUsed, indsYUsed)]

    # mask the non-target zone away from the histograms
    m = np.reshape(mask, (np.prod(mask.shape), 1)).flatten()
    inds = m.nonzero()
    Htemp = np.reshape(H, (np.prod(H.shape), 1)).flatten()
    Htemp = Htemp[inds]
    [fk, kappaBins] = histogram(Htemp, 80)
    Htemp = None

    # mask the margins away from the histograms
    fk = fk / np.trapz(kappaBins, fk)
    cfk = np.cumsum(fk) / np.sum(fk)
    eps = 0.05
    i1 = np.argmin(np.abs(cfk-eps))
    i2 = np.argmin(np.abs(cfk-(1-eps)))
    Hmin = kappaBins[i1]
    Hmax = kappaBins[i2]  # 90 % of values within [Hmin,Hmax]

    sTemp = np.reshape(s, (np.prod(s.shape), 1))
    sTemp = sTemp[inds]
    [fs, sBins] = histogram(sTemp, 80)
    fs = fs / np.trapz(sBins, fs)
    # TODO: sMin and sMax aren't used so these aren't needed
    #cfs = np.cumsum(fs) / np.sum(fs)
    #eps = 0.005
    #i3 = np.argmin(np.abs(cfs-eps))
    #i4 = np.argmin(np.abs(cfs-(1-eps)))
    #sMin = sBins[i3]
    # sMax = sBins[i4]  # 90 % of values within [sMin,sMax]

    create_ks_histograms(fk, kappaBins, fs, sBins)
    create_curvature_image(delta, H, Hmin, Hmax)
    create_aspect_index_image(A)
    create_slope_image(delta, s)

    print("Ready.")
