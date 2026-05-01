from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from typing import List, Optional

from core.database import get_db
from core.security import get_current_user, get_current_admin
from models.campus_poi_model import CampusPOIModel
from models.user_model import UserModel
from schemas.misc_schemas import CampusPOICreateRequest, CampusPOIResponse

router = APIRouter(prefix="/map", tags=["🗺️ Campus Map"])


@router.get(
    "/pois",
    response_model=List[CampusPOIResponse],
    summary="Get all campus points of interest",
)
def get_pois(
    category: Optional[str] = Query(None, description="Filter: Academic, Food, Library, Housing"),
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_user),
):
    """
    Returns all active campus POIs for the map screen.  
    Demonstrates **Location/GPS** integration — the client overlays these on a live map.
    """
    q = db.query(CampusPOIModel).filter(CampusPOIModel.is_active == True)
    if category:
        q = q.filter(CampusPOIModel.category == category)
    return q.all()


@router.get(
    "/pois/{poi_id}",
    response_model=CampusPOIResponse,
    summary="Get a single POI by ID",
)
def get_poi(
    poi_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_user),
):
    poi = db.query(CampusPOIModel).filter(CampusPOIModel.id == poi_id).first()
    if not poi:
        raise HTTPException(status_code=404, detail="POI not found")
    return poi


@router.post(
    "/pois",
    response_model=CampusPOIResponse,
    summary="[Admin] Add a campus POI",
    status_code=status.HTTP_201_CREATED,
)
def create_poi(
    payload: CampusPOICreateRequest,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    """Add a new point of interest to the campus map. Requires **staff** privileges."""
    poi = CampusPOIModel(**payload.model_dump())
    db.add(poi)
    db.commit()
    db.refresh(poi)
    return poi


@router.put(
    "/pois/{poi_id}",
    response_model=CampusPOIResponse,
    summary="[Admin] Update a POI",
)
def update_poi(
    poi_id: int,
    payload: CampusPOICreateRequest,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    poi = db.query(CampusPOIModel).filter(CampusPOIModel.id == poi_id).first()
    if not poi:
        raise HTTPException(status_code=404, detail="POI not found")
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(poi, field, value)
    db.commit()
    db.refresh(poi)
    return poi


@router.delete(
    "/pois/{poi_id}",
    summary="[Admin] Remove a POI from the map",
    status_code=status.HTTP_200_OK,
)
def delete_poi(
    poi_id: int,
    db: Session = Depends(get_db),
    _: UserModel = Depends(get_current_admin),
):
    poi = db.query(CampusPOIModel).filter(CampusPOIModel.id == poi_id).first()
    if not poi:
        raise HTTPException(status_code=404, detail="POI not found")
    db.delete(poi)
    db.commit()
    return {"message": "POI removed"}