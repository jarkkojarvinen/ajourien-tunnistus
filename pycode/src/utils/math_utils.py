import numpy as np


def histogram(x, nbins):
    """
    Matlab hist(x, nbins) equivalent implementation.
    Returns (counts, center).
    Where 
        - counts=a row vector, counts, containing the number of elements in each bin,
        - centers=a row vector, centers, indicating the location of each bin center on the x-axis.

    See details: https://se.mathworks.com/help/matlab/ref/hist.html
    """
    bins = np.linspace(np.min(x), np.max(x), nbins, endpoint=False)
    delta = (bins[1] - bins[0])/2
    _, bins = np.histogram(x, bins=bins)
    count, _ = np.histogram(x, nbins)
    bins = np.round(bins+delta, decimals=4)
    return count, bins
