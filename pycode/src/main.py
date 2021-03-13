import numpy as np
import scipy.io as sio
from skimage.filters.rank import entropy
from skimage.morphology import square
from progress.bar import Bar
import matplotlib.pyplot as plt
from .initZs import init_Zs
from .getDirectionalH import get_directional_H
from .schemas.datastruct import DataStruct
from .utils.math_utils import histogram


def run(mat_fname, m=0.03292):
    """
    mat_fname = file path to mat file
    m = grid constant. Default value 0.03292
    """
    print('Reading stuff...')
    temp = sio.loadmat(mat_fname)
    z0 = temp['z'].astype(int)
    sz0 = z0.shape
    mask = temp['mask'].astype(int)
    # Clear temp
    temp = None

    # can be 1,2,4,6,8,... (no odd numbers 3,5,... allowed)
    kSkip = 256
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

    with Bar('Processing directional curvatures', max=nDls) as bar:
        for l in range(0, nDls):
            # work amount...
            bar.next()
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
            counter = 0
            dCounter = 100000
            nAll = np.prod(sz)
            with Bar('Assembling an image from entropy minimae', max=nAll*nDls) as subbar:
                # aspects
                A = np.zeros(H.shape)
                for i in range(0, sz[0]):
                    for j in range(0, sz[1]):
                        if np.mod(counter, dCounter) == 0:
                            subbar.next()
                        counter = counter + 1

                        for k in range(1, nAlphas):
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
    inds = m.ravel().nonzero()[0]
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
    cfs = np.cumsum(fs) / np.sum(fs)
    eps = 0.005
    i3 = np.argmin(np.abs(cfs-eps))
    i4 = np.argmin(np.abs(cfs-(1-eps)))
    sMin = sBins[i3]
    sMax = sBins[i4]  # 90 % of values within [sMin,sMax]

    # Figure 1
    plt.rcParams.update({'font.size': 12})
    fig1, ((f1ax1, f1ax2)) = plt.subplots(nrows=1, ncols=2)
    f1ax1.set_xscale('log')
    f1ax1.set_yscale('log')
    f1ax1.semilogy(kappaBins, fk)
    f1ax1.set_xlabel(r'$\kappa$ (m$^{-1}$)')
    f1ax1.set_ylabel('freq (m)')
    f1ax1.set_title(r'$\kappa$ histogram')

    f1ax2.set_xscale('log')
    f1ax2.set_yscale('log')
    f1ax2.semilogy(sBins, fs)
    f1ax2.set_xlabel('slope (1)')
    f1ax2.set_ylabel('freq. (1)')
    f1ax2.set_title('slope histogram')

    fig2, f2ax = plt.subplots()
    pos2 = f2ax.imshow(H, cmap='gray', vmin=Hmin, vmax=Hmax)
    colorbar2 = fig2.colorbar(pos2, ax=f2ax)
    colorbar2.set_label(r'$\kappa$ (m$^{-1}$)')
    f2ax.set_title(fr'curvature with $\delta$={delta:.2f} (m)')

    fig3, f3ax = plt.subplots()
    amin = min(min(A))
    amax = max(max(A))
    pos3 = f3ax.imshow(A, cmap='gray', vmin=amin, vmax=amax)
    colorbar3 = fig3.colorbar(pos3, ax=f3ax)
    colorbar3.set_label(r'k of $\alpha{k}$ (1...8)')
    f3ax.set_title(r'aspect index k of the aspect $\alpha_{k}$')

    fig4, f4ax = plt.subplots()
    pos4 = f4ax.imshow(s, cmap='gray', vmin=0.5, vmax=1)
    colorbar4 = fig4.colorbar(pos4, ax=f4ax)
    f4ax.invert_yaxis()
    colorbar4.set_label('slope (1)')
    f4ax.set_title(fr'slope with $\delta$={delta:.2f} (1)')

    fig1.savefig("figure1.png")
    fig2.savefig("figure2.png")
    fig3.savefig("figure3.png")
    fig4.savefig("figure4.png")
