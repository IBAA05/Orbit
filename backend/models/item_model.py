from sqlalchemy import Column, Integer, String, Boolean
from core.database import Base

class ItemModel(Base):
    """
    Model representation mimicking the 'Model' in MVC structure.
    Represents the 'items' table in the SQLite database.
    """
    __tablename__ = "items"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(String, index=True, nullable=True)
    completed = Column(Boolean, default=False)
