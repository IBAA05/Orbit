from pydantic import BaseModel
from typing import Optional
from datetime import datetime

from models.announcement_model import AnnouncementCategory, AnnouncementTarget


class AnnouncementCreateRequest(BaseModel):
    title: str
    body: str
    category: AnnouncementCategory = AnnouncementCategory.academic
    target_audience: AnnouncementTarget = AnnouncementTarget.all
    is_published: bool = True
    send_push_notification: bool = True
    scheduled_at: Optional[datetime] = None
    banner_image_url: Optional[str] = None

    model_config = {"json_schema_extra": {"example": {
        "title": "Midterm Examination Schedule Released",
        "body": "The Office of the Registrar has officially released the schedule...",
        "category": "Academic",
        "target_audience": "All",
        "is_published": True,
        "send_push_notification": True
    }}}


class AnnouncementUpdateRequest(BaseModel):
    title: Optional[str] = None
    body: Optional[str] = None
    category: Optional[AnnouncementCategory] = None
    target_audience: Optional[AnnouncementTarget] = None
    is_published: Optional[bool] = None
    send_push_notification: Optional[bool] = None
    scheduled_at: Optional[datetime] = None
    banner_image_url: Optional[str] = None


class AuthorSummary(BaseModel):
    id: int
    full_name: str
    is_staff: bool

    model_config = {"from_attributes": True}


class AnnouncementResponse(BaseModel):
    id: int
    title: str
    body: str
    category: str
    target_audience: str
    is_published: bool
    send_push_notification: bool
    scheduled_at: Optional[datetime]
    banner_image_url: Optional[str]
    author_id: int
    author: AuthorSummary
    read_count: int
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class AnnouncementListResponse(BaseModel):
    id: int
    title: str
    body: str
    category: str
    target_audience: str
    is_published: bool
    author_id: int
    created_at: datetime

    model_config = {"from_attributes": True}