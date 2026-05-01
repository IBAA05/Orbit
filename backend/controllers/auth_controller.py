from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from core.database import get_db
from core.security import (
    hash_password,
    verify_password,
    create_access_token,
    get_current_user,
)
from models.user_model import UserModel
from schemas.user_schema import (
    UserRegisterRequest,
    UserLoginRequest,
    BiometricLoginRequest,
    TokenResponse,
)

router = APIRouter(prefix="/auth", tags=["🔐 Authentication"])


@router.post(
    "/register",
    response_model=TokenResponse,
    summary="Register a new student account",
    status_code=status.HTTP_201_CREATED,
)
def register(payload: UserRegisterRequest, db: Session = Depends(get_db)):
    """
    Create a new student account.
    Returns a JWT access token on success.
    """
    if db.query(UserModel).filter(UserModel.email == payload.email).first():
        raise HTTPException(status_code=400, detail="Email already registered")

    initials = "".join([w[0].upper() for w in payload.full_name.split()[:2]])
    user = UserModel(
        full_name=payload.full_name,
        email=payload.email,
        student_id=payload.student_id,
        hashed_password=hash_password(payload.password),
        avatar_initials=initials,
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    token = create_access_token({"sub": str(user.id)})
    return TokenResponse(
        access_token=token,
        user_id=user.id,
        full_name=user.full_name,
        is_staff=user.is_staff,
    )


@router.post(
    "/login",
    response_model=TokenResponse,
    summary="Login with email and password",
)
def login(payload: UserLoginRequest, db: Session = Depends(get_db)):
    """
    Authenticate with email and password.
    Returns a JWT access token valid for 7 days.
    """
    user = db.query(UserModel).filter(UserModel.email == payload.email).first()
    if not user or not verify_password(payload.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid email or password")
    if not user.is_active:
        raise HTTPException(status_code=403, detail="Account is deactivated")

    token = create_access_token({"sub": str(user.id)})
    return TokenResponse(
        access_token=token,
        user_id=user.id,
        full_name=user.full_name,
        is_staff=user.is_staff,
    )


@router.post(
    "/biometric-login",
    response_model=TokenResponse,
    summary="Login via biometric token (fingerprint/face)",
)
def biometric_login(payload: BiometricLoginRequest, db: Session = Depends(get_db)):
    """
    Authenticate using a device-issued biometric token.
    The token is validated server-side by checking that the user exists and
    the token is non-empty (full hardware attestation is handled on-device).
    """
    if not payload.biometric_token or len(payload.biometric_token) < 8:
        raise HTTPException(status_code=400, detail="Invalid biometric token")

    user = db.query(UserModel).filter(UserModel.email == payload.email).first()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail="User not found or inactive")

    token = create_access_token({"sub": str(user.id)})
    return TokenResponse(
        access_token=token,
        user_id=user.id,
        full_name=user.full_name,
        is_staff=user.is_staff,
    )


@router.post(
    "/logout",
    summary="Logout (invalidate session client-side)",
    status_code=status.HTTP_200_OK,
)
def logout(current_user: UserModel = Depends(get_current_user)):
    """
    Signals a logout.
    JWT tokens are stateless; the client must discard the token on receipt of this response.
    """
    return {"message": f"User '{current_user.full_name}' logged out successfully."}