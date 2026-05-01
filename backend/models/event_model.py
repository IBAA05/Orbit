from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime

from core.database import Base


class EventModel(Base):
    """Campus event model — created by admin/staff."""

    __tablename__ = "events"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False, index=True)
    description = Column(String, nullable=True)
    location = Column(String, nullable=True)
    event_date = Column(DateTime, nullable=False)
    end_time = Column(DateTime, nullable=True)
    capacity = Column(Integer, default=100)
    event_type = Column(String, default="Workshop")       # Workshop, Seminar, Social, Sport, Other
    cover_image_url = Column(String, nullable=True)
    registration_deadline = Column(DateTime, nullable=True)
    is_published = Column(Boolean, default=True)
    is_draft = Column(Boolean, default=False)
    author_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    author = relationship("UserModel", back_populates="events")
    registrations = relationship("EventRegistrationModel", back_populates="event")
    photo_notes = relationship("PhotoNoteModel", back_populates="event")

    @property
    def registered_count(self) -> int:
        return len(self.registrations) if self.registrations else 0

    @property
    def is_full(self) -> bool:
        return self.registered_count >= self.capacity