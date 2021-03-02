class DataStruct():
    """
    Data object to hold curvature, entropy and slope
    """

    def __init__(self, H=[], J=[], s=[]):
        """
        H = Curvature,
        J = Entrory,
        s = slope
        """

        self.H = H
        self.J = J
        self.s = s
