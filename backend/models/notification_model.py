from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime

from core.database import Base


class NotificationModel(Base):
    """In-app notification for a specific user."""

    __tablename__ = "notifications"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    title = Column(String, nullable=False)
    body = Column(String, nullable=False)
    icon_type = Column(String, default="info")             # info, alert, event, package
    is_read = Column(Boolean, default=False)
    deep_link_route = Column(String, nullable=True)        # e.g. /announcement/5
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("UserModel", back_populates="notifications")