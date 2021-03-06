import matplotlib.pyplot as plt


def create_ks_histograms(fk, kappaBins, fs, sBins):
    """
    Figure 1
    """
    # TODO: käyrät puuttuu
    print("Creating kappa and slope histograms...")
    plt.rcParams.update({'font.size': 12})
    fig, (ax1, ax2) = plt.subplots(nrows=1, ncols=2)
    ax1.semilogy(kappaBins, fk)
    ax1.set_xlabel(r'$\kappa$ (m$^{-1}$)')
    ax1.set_ylabel('freq (m)')
    ax1.set_title(r'$\kappa$ histogram')

    ax2.semilogy(sBins, fs)
    ax2.set_xlabel('slope (1)')
    ax2.set_ylabel('freq. (1)')
    ax2.set_title('slope histogram')

    fig.tight_layout()
    fig.savefig("figure1.png")


def create_curvature_image(delta, H, Hmin, Hmax):
    """
    Figure 2
    """
    print("Creating curvature image...")
    plt.rcParams.update({'font.size': 12})
    fig, ax = plt.subplots()
    ax.set_yticks([])
    ax.set_xticks([])
    pos = ax.imshow(H, cmap='gray', vmin=Hmin, vmax=Hmax)
    colorbar = fig.colorbar(pos, ax=ax)
    colorbar.set_label(r'$\kappa$ (m$^{-1}$)')
    ax.set_title(fr'curvature with $\delta$={delta:.2f} (m)')

    fig.tight_layout()
    fig.savefig("figure2.png")


def create_aspect_index_image(A):
    """
    Figure 3
    """
    # TODO: Suttuinen ja scale pitäis olla 1...12
    print("Creating aspect index image...")
    plt.rcParams.update({'font.size': 12})
    fig, ax = plt.subplots()
    ax.set_yticks([])
    ax.set_xticks([])
    amin = A.min()
    amax = A.max()
    pos = ax.imshow(A, cmap='gray', vmin=amin, vmax=amax)
    colorbar = fig.colorbar(pos, ax=ax)
    colorbar.set_label(r'k of $\alpha{k}$ (1...8)')
    ax.set_title(r'aspect index k of the aspect $\alpha_{k}$')

    fig.tight_layout()
    fig.savefig("figure3.png")


def create_slope_image(delta, s, sMin=0.5, sMax=1.0):
    """
    Figure 4
    """
    print("Creating slope image...")
    plt.rcParams.update({'font.size': 12})
    fig, ax = plt.subplots()
    ax.set_yticks([])
    ax.set_xticks([])
    pos = ax.imshow(s, cmap='gray', vmin=sMin, vmax=sMax)
    colorbar = fig.colorbar(pos, ax=ax)
    colorbar.set_label('slope (1)')
    ax.set_title(fr'slope with $\delta$={delta:.2f} (1)')

    fig.tight_layout()
    fig.savefig("figure4.png")
