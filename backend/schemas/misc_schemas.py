from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


# ─── Feed Post ───────────────────────────────────────────────────────────────

class FeedPostCreateRequest(BaseModel):
    tag: str                            # ANNOUNCEMENT, CAMPUS EVENT, CLUB NEWS, REMINDER
    title: str
    body: str
    image_url: Optional[str] = None
    author_label: str = "Student Council"
    is_pinned: bool = False

    model_config = {"json_schema_extra": {"example": {
        "tag": "ANNOUNCEMENT",
        "title": "Library hours extended for Finals Week",
        "body": "Good news! Starting Monday, the Main Library will be open until midnight.",
        "author_label": "Student Council",
        "is_pinned": True
    }}}


class FeedPostUpdateRequest(BaseModel):
    tag: Optional[str] = None
    title: Optional[str] = None
    body: Optional[str] = None
    image_url: Optional[str] = None
    author_label: Optional[str] = None
    is_pinned: Optional[bool] = None


class FeedPostResponse(BaseModel):
    id: int
    tag: str
    title: str
    body: str
    image_url: Optional[str]
    author_label: str
    seen_count: int
    is_pinned: bool
    time_ago: str                       # Computed: "2m ago", "1h ago"
    created_at: datetime

    model_config = {"from_attributes": True}


# ─── Notification ─────────────────────────────────────────────────────────────

class NotificationCreateRequest(BaseModel):
    user_id: int
    title: str
    body: str
    icon_type: str = "info"
    deep_link_route: Optional[str] = None

    model_config = {"json_schema_extra": {"example": {
        "user_id": 1,
        "title": "Registration Deadline",
        "body": "The registration window for Semester 2 closes in 4 hours.",
        "icon_type": "event",
        "deep_link_route": "/announcements"
    }}}


class NotificationResponse(BaseModel):
    id: int
    user_id: int
    title: str
    body: str
    icon_type: str
    is_read: bool
    deep_link_route: Optional[str]
    created_at: datetime

    model_config = {"from_attributes": True}


# ─── Timetable ────────────────────────────────────────────────────────────────

class TimetableEntryCreateRequest(BaseModel):
    subject: str
    instructor: Optional[str] = None
    location: Optional[str] = None
    day_of_week: str                    # Mon, Tue, Wed, Thu, Fri
    start_time: str                     # "09:00"
    end_time: str                       # "10:30"
    color_hex: str = "#0D6E53"
    semester: Optional[str] = None

    model_config = {"json_schema_extra": {"example": {
        "subject": "Advanced Algorithms",
        "instructor": "Dr. Sarah Chen",
        "location": "Lecture Hall 4B",
        "day_of_week": "Mon",
        "start_time": "09:00",
        "end_time": "10:30",
        "color_hex": "#0D6E53",
        "semester": "Fall 2024"
    }}}


class TimetableEntryUpdateRequest(BaseModel):
    subject: Optional[str] = None
    instructor: Optional[str] = None
    location: Optional[str] = None
    day_of_week: Optional[str] = None
    start_time: Optional[str] = None
    end_time: Optional[str] = None
    color_hex: Optional[str] = None
    semester: Optional[str] = None


class TimetableEntryResponse(BaseModel):
    id: int
    user_id: int
    subject: str
    instructor: Optional[str]
    location: Optional[str]
    day_of_week: str
    start_time: str
    end_time: str
    color_hex: str
    semester: Optional[str]

    model_config = {"from_attributes": True}


# ─── Campus POI ───────────────────────────────────────────────────────────────

class CampusPOICreateRequest(BaseModel):
    name: str
    category: str = "Academic"
    description: Optional[str] = None
    latitude: float
    longitude: float
    distance_meters: Optional[int] = None
    opening_hours: Optional[str] = None
    status: Optional[str] = None
    icon_type: str = "school"
    image_url: Optional[str] = None

    model_config = {"json_schema_extra": {"example": {
        "name": "Science Library",
        "category": "Library",
        "latitude": 36.7538,
        "longitude": 3.0588,
        "distance_meters": 200,
        "opening_hours": "Open until 8PM",
        "status": "Open",
        "icon_type": "library_books"
    }}}


class CampusPOIResponse(BaseModel):
    id: int
    name: str
    category: str
    description: Optional[str]
    latitude: float
    longitude: float
    distance_meters: Optional[int]
    opening_hours: Optional[str]
    status: Optional[str]
    icon_type: str
    image_url: Optional[str]
    is_active: bool

    model_config = {"from_attributes": True}


# ─── Photo Note ───────────────────────────────────────────────────────────────

class PhotoNoteResponse(BaseModel):
    id: int
    user_id: int
    event_id: int
    image_url: str
    caption: Optional[str]
    created_at: datetime

    model_config = {"from_attributes": True}