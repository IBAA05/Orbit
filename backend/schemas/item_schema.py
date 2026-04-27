from pydantic import BaseModel
from typing import Optional

class ItemBase(BaseModel):
    """
    Schema representation mimicking the 'View' behavior in MVC structure.
    Determines how data is validated and what is sent back to the client.
    """
    title: str
    description: Optional[str] = None
    completed: bool = False

class ItemCreate(ItemBase):
    pass

class ItemUpdate(ItemBase):
    pass

class ItemResponse(ItemBase):
    id: int

    class Config:
        from_attributes = True # Allows reading values from SQLAlchemy Models
