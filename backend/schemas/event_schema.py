from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class EventCreateRequest(BaseModel):
    title: str
    description: Optional[str] = None
    location: Optional[str] = None
    event_date: datetime
    end_time: Optional[datetime] = None
    capacity: int = 100
    event_type: str = "Workshop"
    cover_image_url: Optional[str] = None
    registration_deadline: Optional[datetime] = None
    is_published: bool = True
    is_draft: bool = False

    model_config = {"json_schema_extra": {"example": {
        "title": "Tech Fair 2024",
        "description": "Join us for the largest student-led technology showcase of the year.",
        "location": "Main Courtyard",
        "event_date": "2024-04-14T10:00:00",
        "end_time": "2024-04-14T18:00:00",
        "capacity": 500,
        "event_type": "Workshop",
        "is_published": True
    }}}


class EventUpdateRequest(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    location: Optional[str] = None
    event_date: Optional[datetime] = None
    end_time: Optional[datetime] = None
    capacity: Optional[int] = None
    event_type: Optional[str] = None
    cover_image_url: Optional[str] = None
    registration_deadline: Optional[datetime] = None
    is_published: Optional[bool] = None
    is_draft: Optional[bool] = None


class EventResponse(BaseModel):
    id: int
    title: str
    description: Optional[str]
    location: Optional[str]
    event_date: datetime
    end_time: Optional[datetime]
    capacity: int
    event_type: str
    cover_image_url: Optional[str]
    registration_deadline: Optional[datetime]
    is_published: bool
    is_draft: bool
    author_id: int
    registered_count: int
    is_full: bool
    status: str                         # "Open", "Full", "Draft"
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class EventListResponse(BaseModel):
    id: int
    title: str
    location: Optional[str]
    event_date: datetime
    capacity: int
    event_type: str
    registered_count: int
    is_full: bool
    status: str

    model_config = {"from_attributes": True}


class EventRegistrationResponse(BaseModel):
    id: int
    event_id: int
    user_id: int
    registered_at: datetime

    model_config = {"from_attributes": True}