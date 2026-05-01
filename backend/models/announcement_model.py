from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from datetime import datetime
import enum

from core.database import Base


class AnnouncementCategory(str, enum.Enum):
    academic = "Academic"
    urgent = "Urgent"
    event = "Event"
    admin = "Admin"
    other = "Other"


class AnnouncementTarget(str, enum.Enum):
    all = "All"
    custom = "Custom"


class AnnouncementModel(Base):
    """Announcement model — published by staff, visible to students."""

    __tablename__ = "announcements"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False, index=True)
    body = Column(String, nullable=False)
    category = Column(String, default=AnnouncementCategory.academic)
    target_audience = Column(String, default=AnnouncementTarget.all)
    is_published = Column(Boolean, default=True)
    send_push_notification = Column(Boolean, default=True)
    scheduled_at = Column(DateTime, nullable=True)         # None = publish now
    banner_image_url = Column(String, nullable=True)
    author_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    author = relationship("UserModel", back_populates="announcements")
    read_receipts = relationship("AnnouncementReadReceiptModel", back_populates="announcement")