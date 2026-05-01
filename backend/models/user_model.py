from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from core.database import Base


class UserModel(Base):
    """User model — covers both students and staff."""

    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    student_id = Column(String, unique=True, nullable=True)
    hashed_password = Column(String, nullable=False)
    avatar_initials = Column(String, nullable=True)          # e.g. "IL"
    department = Column(String, nullable=True)
    is_staff = Column(Boolean, default=False)               # Admin flag
    is_active = Column(Boolean, default=True)
    dark_mode = Column(Boolean, default=False)
    notifications_enabled = Column(Boolean, default=True)
    language = Column(String, default="English")
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    announcements = relationship("AnnouncementModel", back_populates="author")
    events = relationship("EventModel", back_populates="author")
    event_registrations = relationship("EventRegistrationModel", back_populates="user")
    notifications = relationship("NotificationModel", back_populates="user")
    photo_notes = relationship("PhotoNoteModel", back_populates="user")