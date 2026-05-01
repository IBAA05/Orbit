from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime

from core.database import Base


class FeedPostModel(Base):
    """Campus Feed post — broadcasts from Student Council or admin."""

    __tablename__ = "feed_posts"

    id = Column(Integer, primary_key=True, index=True)
    tag = Column(String, nullable=False)                   # ANNOUNCEMENT, CAMPUS EVENT, CLUB NEWS, REMINDER
    title = Column(String, nullable=False, index=True)
    body = Column(String, nullable=False)
    image_url = Column(String, nullable=True)
    author_label = Column(String, default="Student Council")  # Display name
    seen_count = Column(Integer, default=0)
    is_pinned = Column(Boolean, default=False)
    author_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)