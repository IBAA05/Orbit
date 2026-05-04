from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from typing import List, Optional

from core.database import get_db
from core.security import get_current_user, get_current_admin
from models.announcement_model import AnnouncementModel
from models.read_receipt_model import AnnouncementReadReceiptModel
from models.user_model import UserModel
from schemas.announcement_schema import (
    AnnouncementCreateRequest,
    AnnouncementUpdateRequest,
    AnnouncementResponse,
    AnnouncementListResponse,
)

router = APIRouter(prefix="/announcements", tags=["📢 Announcements"])


def _build_response(a: AnnouncementModel) -> dict:
    res = {c.name: getattr(a, c.name) for c in a.__table__.columns}
    res["read_count"] = len(a.read_receipts) if a.read_receipts else 0
    res["author"] = a.author
    return res


@router.get(
    "/",
    response_model=List[AnnouncementListResponse],
    summary="List all published announcements",
)
def list_announcements(
    category: Optional[str] = Query(None, description="Filter by category (Academic, Urgent, Event, Admin, Other)"),
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_user),
):
    """
    Returns paginated, published announcements ordered newest-first.
    Optionally filter by **category**.
    """
    q = db.query(AnnouncementModel).filter(AnnouncementModel.is_published == True)
    if category:
        q = q.filter(AnnouncementModel.category == category)
    return q.order_by(AnnouncementModel.created_at.desc()).offset(skip).limit(limit).all()


@router.get(
    "/{announcement_id}",
    response_model=AnnouncementResponse,
    summary="Get a single announcement by ID",
)
def get_announcement(
    announcement_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_user),
):
    a = db.query(AnnouncementModel).filter(AnnouncementModel.id == announcement_id).first()
    if not a:
        raise HTTPException(status_code=404, detail="Announcement not found")
    return _build_response(a)


@router.post(
    "/{announcement_id}/read",
    summary="Mark an announcement as read",
    status_code=status.HTTP_200_OK,
)
def mark_as_read(
    announcement_id: int,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    """
    Records a read receipt for the current user on the specified announcement.
    Idempotent — calling it multiple times is safe.
    """
    a = db.query(AnnouncementModel).filter(AnnouncementModel.id == announcement_id).first()
    if not a:
        raise HTTPException(status_code=404, detail="Announcement not found")

    existing = db.query(AnnouncementReadReceiptModel).filter_by(
        announcement_id=announcement_id, user_id=current_user.id
    ).first()
    if not existing:
        receipt = AnnouncementReadReceiptModel(
            announcement_id=announcement_id, user_id=current_user.id
        )
        db.add(receipt)
        db.commit()

    return {"message": "Marked as read"}


# ─── Admin Endpoints ──────────────────────────────────────────────────────────

@router.post(
    "/",
    response_model=AnnouncementResponse,
    summary="[Admin] Publish a new announcement",
    status_code=status.HTTP_201_CREATED,
)
def create_announcement(
    payload: AnnouncementCreateRequest,
    db: Session = Depends(get_db),
    current_admin: UserModel = Depends(get_current_admin),
):
    """
    Create and optionally schedule a new announcement.
    Requires **staff** privileges.
    """
    a = AnnouncementModel(**payload.model_dump(), author_id=current_admin.id)
    db.add(a)
    db.commit()
    db.refresh(a)

    # OS Concept: Broadcast a System-Wide Notification
    from models.notification_model import NotificationModel
    users = db.query(UserModel).filter(UserModel.id != current_admin.id).all()
    for user in users:
        new_notif = NotificationModel(
            user_id=user.id,
            title="Update: " + a.title,
            body=a.body[:100] + "...",
            icon_type="alert" if a.category == "Urgent" else "info",
            is_read=False,
            deep_link_route=f"/announcement/{a.id}"
        )
        db.add(new_notif)
    db.commit()

    return _build_response(a)


@router.put(
    "/{announcement_id}",
    response_model=AnnouncementResponse,
    summary="[Admin] Edit an existing announcement",
)
def update_announcement(
    announcement_id: int,
    payload: AnnouncementUpdateRequest,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    a = db.query(AnnouncementModel).filter(AnnouncementModel.id == announcement_id).first()
    if not a:
        raise HTTPException(status_code=404, detail="Announcement not found")
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(a, field, value)
    db.commit()
    db.refresh(a)
    return _build_response(a)


@router.delete(
    "/{announcement_id}",
    summary="[Admin] Delete an announcement",
    status_code=status.HTTP_200_OK,
)
def delete_announcement(
    announcement_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    a = db.query(AnnouncementModel).filter(AnnouncementModel.id == announcement_id).first()
    if not a:
        raise HTTPException(status_code=404, detail="Announcement not found")
    db.delete(a)
    db.commit()
    return {"message": "Announcement deleted"}


@router.get(
    "/admin/all",
    response_model=List[AnnouncementListResponse],
    summary="[Admin] List ALL announcements including drafts",
)
def admin_list_all(
    skip: int = 0,
    limit: int = 50,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    """Returns all announcements (published + draft) for the admin panel."""
    return (
        db.query(AnnouncementModel)
        .order_by(AnnouncementModel.created_at.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )