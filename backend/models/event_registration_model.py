from sqlalchemy import Column, Integer, ForeignKey, DateTime, UniqueConstraint
from sqlalchemy.orm import relationship
from datetime import datetime

from core.database import Base


class EventRegistrationModel(Base):
    """Tracks user registrations (spot reservations) for events."""

    __tablename__ = "event_registrations"
    __table_args__ = (UniqueConstraint("event_id", "user_id", name="uq_event_registration"),)

    id = Column(Integer, primary_key=True, index=True)
    event_id = Column(Integer, ForeignKey("events.id", ondelete="CASCADE"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    registered_at = Column(DateTime, default=datetime.utcnow)

    event = relationship("EventModel", back_populates="registrations")
    user = relationship("UserModel", back_populates="event_registrations")