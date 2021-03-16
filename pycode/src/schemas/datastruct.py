class DataStruct():
    """
    Data object to hold curvature, entropy and slope
    """

    def __init__(self, H=None, J=None, s=None):
        """
        H = Curvature,
        J = Entrory,
        s = slope
        """
        if isinstance(H, type(None)):
            H = []
        self.H = H

        if isinstance(J, type(None)):
            J = []
        self.J = J

        if isinstance(s, type(None)):
            H = s
        self.s = s
