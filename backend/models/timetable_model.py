from sqlalchemy import Column, Integer, String, ForeignKey, Time
from sqlalchemy.orm import relationship

from core.database import Base


class TimetableEntryModel(Base):
    """A single class/lecture entry in a student's weekly schedule."""

    __tablename__ = "timetable_entries"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    subject = Column(String, nullable=False)
    instructor = Column(String, nullable=True)
    location = Column(String, nullable=True)
    day_of_week = Column(String, nullable=False)           # Mon, Tue, Wed, Thu, Fri
    start_time = Column(String, nullable=False)            # "09:00"
    end_time = Column(String, nullable=False)              # "10:30"
    color_hex = Column(String, default="#0D6E53")          # Card accent color
    semester = Column(String, nullable=True)               # e.g. "Fall 2024"