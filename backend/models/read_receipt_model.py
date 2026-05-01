from sqlalchemy import Column, Integer, ForeignKey, DateTime, UniqueConstraint
from sqlalchemy.orm import relationship
from datetime import datetime

from core.database import Base


class AnnouncementReadReceiptModel(Base):
    """Tracks which users have marked an announcement as read."""

    __tablename__ = "announcement_read_receipts"
    __table_args__ = (UniqueConstraint("announcement_id", "user_id", name="uq_read_receipt"),)

    id = Column(Integer, primary_key=True, index=True)
    announcement_id = Column(Integer, ForeignKey("announcements.id", ondelete="CASCADE"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    read_at = Column(DateTime, default=datetime.utcnow)

    announcement = relationship("AnnouncementModel", back_populates="read_receipts")