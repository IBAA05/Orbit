from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime, timezone

from core.database import get_db
from core.security import get_current_user, get_current_admin
from models.feed_post_model import FeedPostModel
from models.user_model import UserModel
from schemas.misc_schemas import FeedPostCreateRequest, FeedPostUpdateRequest, FeedPostResponse

router = APIRouter(prefix="/feed", tags=["⚡ Campus Feed"])


def _time_ago(dt: datetime) -> str:
    now = datetime.utcnow()
    diff = now - dt
    seconds = int(diff.total_seconds())
    if seconds < 60:
        return f"{seconds}s ago"
    if seconds < 3600:
        return f"{seconds // 60}m ago"
    if seconds < 86400:
        return f"{seconds // 3600}h ago"
    return f"{diff.days}d ago"


def _to_response(post: FeedPostModel) -> dict:
    return {**{c.name: getattr(post, c.name) for c in post.__table__.columns},
            "time_ago": _time_ago(post.created_at)}


@router.get(
    "/",
    response_model=List[FeedPostResponse],
    summary="Get the campus feed (newest first)",
)
def get_feed(
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_user),
):
    """Returns campus feed posts, pinned items first then newest."""
    posts = (
        db.query(FeedPostModel)
        .order_by(FeedPostModel.is_pinned.desc(), FeedPostModel.created_at.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )
    return [_to_response(p) for p in posts]


@router.get(
    "/{post_id}",
    response_model=FeedPostResponse,
    summary="Get a single feed post",
)
def get_post(
    post_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_user),
):
    post = db.query(FeedPostModel).filter(FeedPostModel.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Feed post not found")
    # Increment seen counter
    post.seen_count += 1
    db.commit()
    return _to_response(post)


@router.post(
    "/",
    response_model=FeedPostResponse,
    summary="[Admin] Create a feed post",
    status_code=status.HTTP_201_CREATED,
)
def create_post(
    payload: FeedPostCreateRequest,
    db: Session = Depends(get_db),
    current_admin: UserModel = Depends(get_current_admin),
):
    """Publish a new campus feed post. Requires **staff** privileges."""
    post = FeedPostModel(**payload.model_dump(), author_id=current_admin.id)
    db.add(post)
    db.commit()
    db.refresh(post)
    return _to_response(post)


@router.put(
    "/{post_id}",
    response_model=FeedPostResponse,
    summary="[Admin] Update a feed post",
)
def update_post(
    post_id: int,
    payload: FeedPostUpdateRequest,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    post = db.query(FeedPostModel).filter(FeedPostModel.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Feed post not found")
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(post, field, value)
    db.commit()
    db.refresh(post)
    return _to_response(post)


@router.delete(
    "/{post_id}",
    summary="[Admin] Delete a feed post",
    status_code=status.HTTP_200_OK,
)
def delete_post(
    post_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    post = db.query(FeedPostModel).filter(FeedPostModel.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Feed post not found")
    db.delete(post)
    db.commit()
    return {"message": "Post deleted"}