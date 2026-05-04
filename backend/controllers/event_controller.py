from fastapi import APIRouter, Depends, HTTPException, Query, UploadFile, File, status
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from typing import List, Optional
import os, uuid, aiofiles

from core.database import get_db
from core.security import get_current_user, get_current_admin
from models.event_model import EventModel
from models.event_registration_model import EventRegistrationModel
from models.photo_note_model import PhotoNoteModel
from models.user_model import UserModel
from schemas.event_schema import (
    EventCreateRequest,
    EventUpdateRequest,
    EventResponse,
    EventListResponse,
    EventRegistrationResponse,
)
from schemas.misc_schemas import PhotoNoteResponse

router = APIRouter(prefix="/events", tags=["🎉 Events"])

UPLOAD_DIR = "uploads/events"
os.makedirs(UPLOAD_DIR, exist_ok=True)


def _event_status(event: EventModel) -> str:
    if event.is_draft:
        return "Draft"
    if event.registered_count >= event.capacity:
        return "Full"
    return "Open"


def _to_response(event: EventModel) -> dict:
    return {
        **{c.name: getattr(event, c.name) for c in event.__table__.columns},
        "registered_count": event.registered_count,
        "is_full": event.is_full,
        "status": _event_status(event),
    }


@router.get(
    "/",
    response_model=List[EventListResponse],
    summary="List all published events",
)
def list_events(
    event_type: Optional[str] = Query(None, description="Filter by type: Workshop, Seminar, Social, Sport, Other"),
    upcoming_only: bool = Query(True, description="Return only future events"),
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_user),
):
    """Returns paginated published events, optionally filtered by type."""
    from datetime import datetime
    q = db.query(EventModel).filter(EventModel.is_published == True, EventModel.is_draft == False)
    if upcoming_only:
        q = q.filter(EventModel.event_date >= datetime.utcnow())
    if event_type:
        q = q.filter(EventModel.event_type == event_type)
    events = q.order_by(EventModel.event_date.asc()).offset(skip).limit(limit).all()
    return [_to_response(e) for e in events]


@router.get(
    "/{event_id}",
    response_model=EventResponse,
    summary="Get event details",
)
def get_event(
    event_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_user),
):
    event = db.query(EventModel).filter(EventModel.id == event_id).first()
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    return _to_response(event)


@router.post(
    "/{event_id}/register",
    response_model=EventRegistrationResponse,
    summary="Reserve a spot at an event",
    status_code=status.HTTP_201_CREATED,
)
def register_for_event(
    event_id: int,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    """
    Reserve the current user's spot at an event.
    Returns 409 if already registered, 400 if the event is full.
    """
    event = db.query(EventModel).filter(EventModel.id == event_id).first()
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    if event.is_full:
        raise HTTPException(status_code=400, detail="Event is fully booked")

    try:
        reg = EventRegistrationModel(event_id=event_id, user_id=current_user.id)
        db.add(reg)
        db.commit()
        db.refresh(reg)
        return reg
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=409, detail="Already registered for this event")


@router.delete(
    "/{event_id}/register",
    summary="Cancel your registration for an event",
    status_code=status.HTTP_200_OK,
)
def cancel_registration(
    event_id: int,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    reg = db.query(EventRegistrationModel).filter_by(
        event_id=event_id, user_id=current_user.id
    ).first()
    if not reg:
        raise HTTPException(status_code=404, detail="Registration not found")
    db.delete(reg)
    db.commit()
    return {"message": "Registration cancelled"}


@router.get(
    "/{event_id}/registrations",
    response_model=List[EventRegistrationResponse],
    summary="[Admin] List all registrations for an event",
)
def list_registrations(
    event_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    return db.query(EventRegistrationModel).filter_by(event_id=event_id).all()


# ─── Photo Notes ──────────────────────────────────────────────────────────────

@router.post(
    "/{event_id}/photos",
    response_model=PhotoNoteResponse,
    summary="Attach a photo note to an event",
    status_code=status.HTTP_201_CREATED,
)
async def upload_photo_note(
    event_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    """
    Upload an image (JPEG/PNG) as a personal photo note for an event.
    Demonstrates the **Camera/Gallery** device feature from the OS concepts map.
    """
    event = db.query(EventModel).filter(EventModel.id == event_id).first()
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")

    ext = os.path.splitext(file.filename)[1].lower()
    if ext not in (".jpg", ".jpeg", ".png", ".webp"):
        raise HTTPException(status_code=400, detail="Only image files are accepted")

    filename = f"{uuid.uuid4().hex}{ext}"
    filepath = os.path.join(UPLOAD_DIR, filename)
    async with aiofiles.open(filepath, "wb") as out:
        await out.write(await file.read())

    note = PhotoNoteModel(
        user_id=current_user.id,
        event_id=event_id,
        image_url=f"/{filepath}",
    )
    db.add(note)
    db.commit()
    db.refresh(note)
    return note


@router.get(
    "/{event_id}/photos",
    response_model=List[PhotoNoteResponse],
    summary="Get my photo notes for an event",
)
def get_my_photo_notes(
    event_id: int,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    return db.query(PhotoNoteModel).filter_by(event_id=event_id, user_id=current_user.id).all()


# ─── Admin CRUD ───────────────────────────────────────────────────────────────

@router.post(
    "/",
    response_model=EventResponse,
    summary="[Admin] Create a new event",
    status_code=status.HTTP_201_CREATED,
)
def create_event(
    payload: EventCreateRequest,
    db: Session = Depends(get_db),
    current_admin: UserModel = Depends(get_current_admin),
):
    """Create a campus event. Requires **staff** privileges."""
    event = EventModel(**payload.model_dump(), author_id=current_admin.id)
    db.add(event)
    db.commit()
    db.refresh(event)
    
    # OS Concept: Simulate a Push Notification broadcast
    # Create a notification record for every user (excluding the author)
    from models.notification_model import NotificationModel
    users = db.query(UserModel).filter(UserModel.id != current_admin.id).all()
    for user in users:
        new_notif = NotificationModel(
            user_id=user.id,
            title="New Event: " + event.title,
            body=f"Register now! {event.title} is happening at {event.location}.",
            icon_type="event",
            is_read=False,
            deep_link_route="/events"
        )
        db.add(new_notif)
    # OS Concept: Simulate a Cross-Feature Sync (Double Posting)
    # Create an Announcement record so it appears in the student's feed
    from models.announcement_model import AnnouncementModel
    new_announcement = AnnouncementModel(
        title=f"New Event: {event.title}",
        body=f"We are excited to announce a new {event.event_type} at {event.location}. {event.description}",
        category="Event",
        target_audience="All",
        is_published=True,
        author_id=current_admin.id
    )
    db.add(new_announcement)
    
    db.commit()

    return _to_response(event)


@router.put(
    "/{event_id}",
    response_model=EventResponse,
    summary="[Admin] Update an event",
)
def update_event(
    event_id: int,
    payload: EventUpdateRequest,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    event = db.query(EventModel).filter(EventModel.id == event_id).first()
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(event, field, value)
    db.commit()
    db.refresh(event)
    return _to_response(event)


@router.delete(
    "/{event_id}",
    summary="[Admin] Delete an event",
    status_code=status.HTTP_200_OK,
)
def delete_event(
    event_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    event = db.query(EventModel).filter(EventModel.id == event_id).first()
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    db.delete(event)
    db.commit()
    return {"message": "Event deleted"}