"""
Orbit Backend API
=================
Backend service for the **Orbit SmartCampus Companion** Flutter app.

Architecture: MVC-lite with FastAPI routers acting as controllers.
Database:     SQLite via SQLAlchemy ORM (swap to PostgreSQL for production).
Auth:         JWT Bearer tokens (7-day expiry) + Biometric login simulation.

Mobile OS Concepts Demonstrated
--------------------------------
| Concept                  | Backend Endpoint(s)                           |
|--------------------------|-----------------------------------------------|
| Authentication/Security  | POST /auth/register, /auth/login, /auth/biometric-login |
| Secure Storage           | JWT tokens issued here, stored in FlutterSecureStorage on device |
| Networking / REST API    | All endpoints below                           |
| Offline caching          | Clients cache responses; /timetable/export ships a JSON file |
| File I/O                 | GET /timetable/export (download JSON)         |
| Camera/Gallery           | POST /events/{id}/photos (image upload)       |
| Location/GPS             | GET /map/pois (campus POIs overlaid on live map) |
| Notifications            | POST /notifications/send (server push)        |
| Background refresh       | GET /announcements, /feed (called by background task) |
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os

from core.database import engine, Base

# Import all models so SQLAlchemy can register them before create_all
import models  # noqa: F401

# Controllers
from controllers.auth_controller import router as auth_router
from controllers.user_controller import router as user_router
from controllers.announcement_controller import router as announcement_router
from controllers.event_controller import router as event_router
from controllers.feed_controller import router as feed_router
from controllers.notification_controller import router as notification_router
from controllers.timetable_controller import router as timetable_router
from controllers.map_controller import router as map_router

# ─── Create tables ────────────────────────────────────────────────────────────
Base.metadata.create_all(bind=engine)

# ─── Ensure upload dirs exist ─────────────────────────────────────────────────
os.makedirs("uploads/events", exist_ok=True)

# ─── FastAPI app ──────────────────────────────────────────────────────────────
app = FastAPI(
    title="Orbit — SmartCampus Companion API",
    description=__doc__,
    version="2.0.0",
    contact={
        "name": "Orbit Dev Team",
        "email": "dev@orbit-campus.app",
    },
    license_info={
        "name": "MIT",
    },
    openapi_tags=[
        {
            "name": "🔐 Authentication",
            "description": (
                "Register, login (email/password or biometric), and logout.  \n"
                "All protected endpoints require `Authorization: Bearer <token>` header.  \n"
                "**OS Concept:** Security model, biometrics, secure token storage."
            ),
        },
        {
            "name": "👤 User Profile",
            "description": (
                "View and update the current user's profile, preferences, and password.  \n"
                "Admin endpoints allow managing all users.  \n"
                "**OS Concept:** App sandboxing — each user sees only their own data."
            ),
        },
        {
            "name": "📢 Announcements",
            "description": (
                "Browse campus announcements filtered by category.  \n"
                "Students can mark items as read; admins can publish, edit, and delete.  \n"
                "**OS Concept:** Networking (REST fetch), offline caching, background refresh."
            ),
        },
        {
            "name": "🎉 Events",
            "description": (
                "Discover, register for, and manage campus events.  \n"
                "Supports photo notes (image upload) per event.  \n"
                "**OS Concept:** Camera/Gallery permissions, file upload, capacity management."
            ),
        },
        {
            "name": "⚡ Campus Feed",
            "description": (
                "Real-time campus feed posts from Student Council and admin.  \n"
                "Supports pinned posts and seen-by counters.  \n"
                "**OS Concept:** Background data refresh."
            ),
        },
        {
            "name": "🔔 Notifications",
            "description": (
                "In-app notification inbox per user.  \n"
                "Admin can push targeted notifications with deep-link routes.  \n"
                "**OS Concept:** Local notifications, deep-linking via payload."
            ),
        },
        {
            "name": "📅 Timetable / Schedule",
            "description": (
                "Manage the current user's weekly class schedule.  \n"
                "Includes JSON export (File I/O) for offline access.  \n"
                "**OS Concept:** Local persistence, File I/O, offline-first."
            ),
        },
        {
            "name": "🗺️ Campus Map",
            "description": (
                "Points of Interest (POIs) for the interactive campus map.  \n"
                "Returns GPS coordinates that the Flutter app overlays on OpenStreetMap.  \n"
                "**OS Concept:** Location / GPS sensor integration."
            ),
        },
    ],
)

# ─── CORS ─────────────────────────────────────────────────────────────────────
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],          # Restrict to your domain in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ─── Static file serving (uploaded images) ────────────────────────────────────
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

# ─── Routers ──────────────────────────────────────────────────────────────────
app.include_router(auth_router)
app.include_router(user_router)
app.include_router(announcement_router)
app.include_router(event_router)
app.include_router(feed_router)
app.include_router(notification_router)
app.include_router(timetable_router)
app.include_router(map_router)


# ─── Root ─────────────────────────────────────────────────────────────────────
@app.get("/", tags=["🔐 Authentication"], summary="Health check / API info")
def root():
    return {
        "app": "Orbit SmartCampus Companion API",
        "version": "2.0.0",
        "status": "running",
        "docs": "/docs",
        "redoc": "/redoc",
        "endpoints": {
            "auth": "/auth",
            "users": "/users",
            "announcements": "/announcements",
            "events": "/events",
            "feed": "/feed",
            "notifications": "/notifications",
            "timetable": "/timetable",
            "map": "/map",
        },
    }