from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime


class UserRegisterRequest(BaseModel):
    full_name: str
    email: EmailStr
    student_id: Optional[str] = None
    password: str

    model_config = {"json_schema_extra": {"example": {
        "full_name": "Ibaa Lamouri",
        "email": "ibaa@university.edu",
        "student_id": "882910",
        "password": "StrongPass123!"
    }}}


class UserLoginRequest(BaseModel):
    email: EmailStr
    password: str

    model_config = {"json_schema_extra": {"example": {
        "email": "ibaa@university.edu",
        "password": "StrongPass123!"
    }}}


class BiometricLoginRequest(BaseModel):
    """Simulates a biometric token from the device."""
    biometric_token: str
    email: EmailStr

    model_config = {"json_schema_extra": {"example": {
        "biometric_token": "device-fingerprint-hash-abc123",
        "email": "ibaa@university.edu"
    }}}


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: int
    full_name: str
    is_staff: bool


class UserProfileResponse(BaseModel):
    id: int
    full_name: str
    email: str
    student_id: Optional[str]
    avatar_initials: Optional[str]
    department: Optional[str]
    is_staff: bool
    dark_mode: bool
    notifications_enabled: bool
    language: str
    created_at: datetime

    model_config = {"from_attributes": True}


class UserProfileUpdateRequest(BaseModel):
    full_name: Optional[str] = None
    department: Optional[str] = None
    avatar_initials: Optional[str] = None
    dark_mode: Optional[bool] = None
    notifications_enabled: Optional[bool] = None
    language: Optional[str] = None

    model_config = {"json_schema_extra": {"example": {
        "full_name": "Ibaa Lamouri",
        "dark_mode": False,
        "notifications_enabled": True,
        "language": "English"
    }}}


class ChangePasswordRequest(BaseModel):
    current_password: str
    new_password: str