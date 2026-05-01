from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from core.database import Base


class PhotoNoteModel(Base):
    """Photo note attached by a user to a specific event."""

    __tablename__ = "photo_notes"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    event_id = Column(Integer, ForeignKey("events.id", ondelete="CASCADE"), nullable=False)
    image_url = Column(String, nullable=False)
    caption = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("UserModel", back_populates="photo_notes")
    event = relationship("EventModel", back_populates="photo_notes")