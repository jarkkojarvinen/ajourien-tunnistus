import numpy as np


def create_row_vector(start, end, pre=None, post=None):
    """
    Created to support Matlab row vector generation.
    Examples of behaviour:
    a) Let's assume that we have matlab code [2:4, 4] 
        then result is [2, 3, 4, 4]
        This call is equal with create_row_vector(2, 4, post=4)
    b) Let's assume that we have matlab code [1, 1:3] 
        then result is [1, 1, 2, 3]
        This call is equal with create_row_vector(1, 3, pre=1)
    NOTE: If both pre and post given then only pre will be set
    """
    base_list = range(start, end+1)
    if pre is not None:
        return np.concatenate(([pre], base_list), axis=0)
    elif post is not None:
        return np.concatenate((base_list, [post]), axis=0)
    return base_list
