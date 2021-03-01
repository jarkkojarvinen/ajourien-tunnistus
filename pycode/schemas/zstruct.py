from pydantic import BaseModel
from .array import Array


class ZStruct(BaseModel):
    """
    Represents Z item on array used in initZs
    """
    z: Array[Array[int]]
