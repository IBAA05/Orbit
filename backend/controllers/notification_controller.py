from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from core.database import get_db
from core.security import get_current_user, get_current_admin
from models.notification_model import NotificationModel
from models.user_model import UserModel
from schemas.misc_schemas import NotificationCreateRequest, NotificationResponse

router = APIRouter(prefix="/notifications", tags=["🔔 Notifications"])


@router.get(
    "/",
    response_model=List[NotificationResponse],
    summary="Get my notifications",
)
def get_my_notifications(
    unread_only: bool = False,
    skip: int = 0,
    limit: int = 30,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    """Returns the current user's notifications, newest first."""
    q = db.query(NotificationModel).filter(NotificationModel.user_id == current_user.id)
    if unread_only:
        q = q.filter(NotificationModel.is_read == False)
    return q.order_by(NotificationModel.created_at.desc()).offset(skip).limit(limit).all()


@router.put(
    "/{notification_id}/read",
    summary="Mark a notification as read",
    status_code=status.HTTP_200_OK,
)
def mark_notification_read(
    notification_id: int,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    n = db.query(NotificationModel).filter_by(
        id=notification_id, user_id=current_user.id
    ).first()
    if not n:
        raise HTTPException(status_code=404, detail="Notification not found")
    n.is_read = True
    db.commit()
    return {"message": "Marked as read"}


@router.put(
    "/read-all",
    summary="Mark ALL my notifications as read",
    status_code=status.HTTP_200_OK,
)
def mark_all_read(
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    db.query(NotificationModel).filter_by(
        user_id=current_user.id, is_read=False
    ).update({"is_read": True})
    db.commit()
    return {"message": "All notifications marked as read"}


@router.delete(
    "/{notification_id}",
    summary="Delete a notification",
    status_code=status.HTTP_200_OK,
)
def delete_notification(
    notification_id: int,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    n = db.query(NotificationModel).filter_by(
        id=notification_id, user_id=current_user.id
    ).first()
    if not n:
        raise HTTPException(status_code=404, detail="Notification not found")
    db.delete(n)
    db.commit()
    return {"message": "Notification deleted"}


# ─── Admin push endpoint ──────────────────────────────────────────────────────

@router.post(
    "/send",
    response_model=NotificationResponse,
    summary="[Admin] Send a notification to a user",
    status_code=status.HTTP_201_CREATED,
)
def send_notification(
    payload: NotificationCreateRequest,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    """
    Push a notification to a specific user.
    Demonstrates the **Local Notifications** OS concept.
    """
    user = db.query(UserModel).filter(UserModel.id == payload.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Target user not found")

    n = NotificationModel(**payload.model_dump())
    db.add(n)
    db.commit()
    db.refresh(n)
    return n