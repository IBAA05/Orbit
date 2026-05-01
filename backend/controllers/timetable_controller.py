import json, os
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from typing import List, Optional

from core.database import get_db
from core.security import get_current_user
from models.timetable_model import TimetableEntryModel
from models.user_model import UserModel
from schemas.misc_schemas import (
    TimetableEntryCreateRequest,
    TimetableEntryUpdateRequest,
    TimetableEntryResponse,
)

router = APIRouter(prefix="/timetable", tags=["📅 Timetable / Schedule"])


@router.get(
    "/",
    response_model=List[TimetableEntryResponse],
    summary="Get my full weekly timetable",
)
def get_my_timetable(
    day: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    """
    Returns the current user's timetable entries.  
    Optionally filter by **day** (Mon, Tue, Wed, Thu, Fri).
    """
    q = db.query(TimetableEntryModel).filter(TimetableEntryModel.user_id == current_user.id)
    if day:
        q = q.filter(TimetableEntryModel.day_of_week == day)
    return q.order_by(TimetableEntryModel.start_time).all()


@router.post(
    "/",
    response_model=TimetableEntryResponse,
    summary="Add a class to my timetable",
    status_code=status.HTTP_201_CREATED,
)
def add_entry(
    payload: TimetableEntryCreateRequest,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    entry = TimetableEntryModel(**payload.model_dump(), user_id=current_user.id)
    db.add(entry)
    db.commit()
    db.refresh(entry)
    return entry


@router.put(
    "/{entry_id}",
    response_model=TimetableEntryResponse,
    summary="Update a timetable entry",
)
def update_entry(
    entry_id: int,
    payload: TimetableEntryUpdateRequest,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    entry = db.query(TimetableEntryModel).filter_by(
        id=entry_id, user_id=current_user.id
    ).first()
    if not entry:
        raise HTTPException(status_code=404, detail="Entry not found")
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(entry, field, value)
    db.commit()
    db.refresh(entry)
    return entry


@router.delete(
    "/{entry_id}",
    summary="Delete a timetable entry",
    status_code=status.HTTP_200_OK,
)
def delete_entry(
    entry_id: int,
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    entry = db.query(TimetableEntryModel).filter_by(
        id=entry_id, user_id=current_user.id
    ).first()
    if not entry:
        raise HTTPException(status_code=404, detail="Entry not found")
    db.delete(entry)
    db.commit()
    return {"message": "Entry removed"}


@router.get(
    "/export",
    summary="Export my schedule as a JSON file",
    response_class=JSONResponse,
)
def export_schedule(
    db: Session = Depends(get_db),
    current_user: UserModel = Depends(get_current_user),
):
    """
    Returns the full timetable as a downloadable JSON payload.  
    Demonstrates **File I/O** from the OS concepts map.
    """
    entries = db.query(TimetableEntryModel).filter_by(user_id=current_user.id).all()
    data = [
        {
            "subject": e.subject,
            "instructor": e.instructor,
            "location": e.location,
            "day_of_week": e.day_of_week,
            "start_time": e.start_time,
            "end_time": e.end_time,
            "semester": e.semester,
        }
        for e in entries
    ]
    from fastapi.responses import Response
    content = json.dumps({"schedule": data}, indent=2)
    return Response(
        content=content,
        media_type="application/json",
        headers={"Content-Disposition": f"attachment; filename=schedule_{current_user.id}.json"},
    )