import numpy as np


def histogram(x, nbins=10):
    """    
    Matlab hist(x, nbins) equivalent implementation.
    
    Parameters:
        - x = numpy array of items
        - nbins = number of bins

    Returns (counts, center).

    Where 
        - counts=a row vector, counts, containing the number of elements in each bin,
        - centers=a row vector, centers, indicating the location of each bin center on the x-axis.

    See details: https://se.mathworks.com/help/matlab/ref/hist.html
    """
    bins = np.linspace(x.min(), x.max(), nbins, endpoint=False)
    delta = (bins[1] - bins[0])/2
    bins = np.round(bins + delta, decimals=4)
    count, _ = np.histogram(x, bins=nbins)
    return count, bins
