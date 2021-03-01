from typing import List
from pydantic import BaseModel, Field
from .array import Array


class DataStruct(BaseModel):
    """
    Data object to hold curvature, entropy and slope
    """

    H: Array[Array[int]] = Field(description="Curvature")
    J: Array[Array[int]] = Field(description="Entropy")
    s: Array[Array[int]] = Field(description="slope")
