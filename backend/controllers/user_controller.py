from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from core.database import get_db
from core.security import get_current_user, get_current_admin, hash_password, verify_password
from models.user_model import UserModel
from schemas.user_schema import (
    UserProfileResponse,
    UserProfileUpdateRequest,
    ChangePasswordRequest,
)

router = APIRouter(prefix="/users", tags=["👤 User Profile"])


@router.get(
    "/me",
    response_model=UserProfileResponse,
    summary="Get my profile",
)
def get_my_profile(current_user: UserModel = Depends(get_current_user)):
    """Returns the full profile of the currently authenticated user."""
    return current_user


@router.put(
    "/me",
    response_model=UserProfileResponse,
    summary="Update my profile settings",
)
def update_my_profile(
    payload: UserProfileUpdateRequest,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    """
    Update editable profile fields: display name, department, dark mode,
    notification preference, and language.
    """
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(current_user, field, value)
    db.commit()
    db.refresh(current_user)
    return current_user


@router.put(
    "/me/password",
    summary="Change my password",
    status_code=status.HTTP_200_OK,
)
def change_password(
    payload: ChangePasswordRequest,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    """Verify the current password and set a new one."""
    if not verify_password(payload.current_password, current_user.hashed_password):
        raise HTTPException(status_code=400, detail="Current password is incorrect")
    current_user.hashed_password = hash_password(payload.new_password)
    db.commit()
    return {"message": "Password updated successfully"}


# ─── Admin-only endpoints ─────────────────────────────────────────────────────

@router.get(
    "/",
    response_model=List[UserProfileResponse],
    summary="[Admin] List all users",
)
def list_users(
    skip: int = 0,
    limit: int = 50,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    """Returns a paginated list of all registered users. Requires staff privileges."""
    return db.query(UserModel).offset(skip).limit(limit).all()


@router.get(
    "/{user_id}",
    response_model=UserProfileResponse,
    summary="[Admin] Get a user by ID",
)
def get_user_by_id(
    user_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    user = db.query(UserModel).filter(UserModel.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@router.delete(
    "/{user_id}",
    summary="[Admin] Deactivate a user account",
    status_code=status.HTTP_200_OK,
)
def deactivate_user(
    user_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    user = db.query(UserModel).filter(UserModel.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.is_active = False
    db.commit()
    return {"message": f"User {user_id} deactivated"}