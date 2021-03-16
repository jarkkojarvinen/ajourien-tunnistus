class ZStruct():
    """
    Represents Z item on array used in initZs
    """

    def __init__(self, z=None):
        """
        z = array of items
        """
        if isinstance(z, type(None)):
            z = []
        self.z = z
