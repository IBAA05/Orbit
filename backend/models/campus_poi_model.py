from sqlalchemy import Column, Integer, String, Float, Boolean

from core.database import Base


class CampusPOIModel(Base):
    """Point of Interest on the campus map."""

    __tablename__ = "campus_pois"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, index=True)
    category = Column(String, default="Academic")          # Academic, Food, Library, Housing
    description = Column(String, nullable=True)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    distance_meters = Column(Integer, nullable=True)
    opening_hours = Column(String, nullable=True)          # "Open until 8PM"
    status = Column(String, nullable=True)                 # "Open", "Busy", "Closed"
    icon_type = Column(String, default="school")           # school, restaurant, library
    image_url = Column(String, nullable=True)
    is_active = Column(Boolean, default=True)