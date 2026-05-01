# 🛸 Orbit Backend API — v2.0

Full-featured FastAPI backend for the **Orbit SmartCampus Companion** Flutter app.  
48 endpoints · 8 feature groups · JWT Auth · SQLite → swap to Postgres for production.

---

## 🚀 Quick Start

```bash
cd backend

# 1. Create virtual environment (recommended)
python -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Seed the database with demo data
python seed.py

# 4. Start the server
uvicorn main:app --reload
```

API is now live at **http://127.0.0.1:8000**

| Interface | URL |
|-----------|-----|
| Swagger UI (interactive) | http://127.0.0.1:8000/docs |
| ReDoc (clean docs) | http://127.0.0.1:8000/redoc |
| Raw OpenAPI JSON | http://127.0.0.1:8000/openapi.json |

---

## 🔑 Demo Credentials

| Role | Email | Password |
|------|-------|----------|
| **Student** | ibaa@university.edu | Student123! |
| **Admin / Staff** | admin@university.edu | Admin123! |

---

## 📡 API Overview — 48 Endpoints

### 🔐 Authentication (`/auth`)
| Method | Path | Description |
|--------|------|-------------|
| POST | `/auth/register` | Register a new student account → JWT |
| POST | `/auth/login` | Login with email + password → JWT |
| POST | `/auth/biometric-login` | Login via device biometric token → JWT |
| POST | `/auth/logout` | Logout (client discards token) |

> **OS Concept:** Security model, biometrics, JWT secure storage.

---

### 👤 User Profile (`/users`)
| Method | Path | Description |
|--------|------|-------------|
| GET | `/users/me` | Get my profile |
| PUT | `/users/me` | Update name, dept, dark mode, language… |
| PUT | `/users/me/password` | Change password |
| GET | `/users/` | **[Admin]** List all users |
| GET | `/users/{id}` | **[Admin]** Get user by ID |
| DELETE | `/users/{id}` | **[Admin]** Deactivate a user |

---

### 📢 Announcements (`/announcements`)
| Method | Path | Description |
|--------|------|-------------|
| GET | `/announcements/` | List published announcements (filter by category) |
| GET | `/announcements/{id}` | Get announcement details + read count |
| POST | `/announcements/{id}/read` | Mark as read |
| POST | `/announcements/` | **[Admin]** Publish a new announcement |
| PUT | `/announcements/{id}` | **[Admin]** Edit announcement |
| DELETE | `/announcements/{id}` | **[Admin]** Delete announcement |
| GET | `/announcements/admin/all` | **[Admin]** List all (including drafts) |

Categories: `Academic` · `Urgent` · `Event` · `Admin` · `Other`

> **OS Concept:** REST networking, offline caching, background refresh.

---

### 🎉 Events (`/events`)
| Method | Path | Description |
|--------|------|-------------|
| GET | `/events/` | List published events (filter by type, upcoming) |
| GET | `/events/{id}` | Event details with capacity info |
| POST | `/events/{id}/register` | Reserve a spot |
| DELETE | `/events/{id}/register` | Cancel registration |
| GET | `/events/{id}/registrations` | **[Admin]** All registrations |
| POST | `/events/{id}/photos` | Upload a photo note (multipart) |
| GET | `/events/{id}/photos` | My photo notes for this event |
| POST | `/events/` | **[Admin]** Create event |
| PUT | `/events/{id}` | **[Admin]** Edit event |
| DELETE | `/events/{id}` | **[Admin]** Delete event |

> **OS Concept:** Camera/Gallery permissions, file upload, capacity management.

---

### ⚡ Campus Feed (`/feed`)
| Method | Path | Description |
|--------|------|-------------|
| GET | `/feed/` | Get feed (pinned first, then newest) |
| GET | `/feed/{id}` | Get post + increment seen counter |
| POST | `/feed/` | **[Admin]** Create feed post |
| PUT | `/feed/{id}` | **[Admin]** Edit feed post |
| DELETE | `/feed/{id}` | **[Admin]** Delete feed post |

Tags: `ANNOUNCEMENT` · `CAMPUS EVENT` · `CLUB NEWS` · `REMINDER`

---

### 🔔 Notifications (`/notifications`)
| Method | Path | Description |
|--------|------|-------------|
| GET | `/notifications/` | My notifications (filter unread) |
| PUT | `/notifications/{id}/read` | Mark one as read |
| PUT | `/notifications/read-all` | Mark all as read |
| DELETE | `/notifications/{id}` | Delete a notification |
| POST | `/notifications/send` | **[Admin]** Push notification to a user |

> **OS Concept:** Local notifications, deep-linking via `deep_link_route` payload.

---

### 📅 Timetable (`/timetable`)
| Method | Path | Description |
|--------|------|-------------|
| GET | `/timetable/` | My schedule (filter by day: Mon…Fri) |
| POST | `/timetable/` | Add a class entry |
| PUT | `/timetable/{id}` | Update a class entry |
| DELETE | `/timetable/{id}` | Remove a class entry |
| GET | `/timetable/export` | **Download schedule as JSON** |

> **OS Concept:** Local persistence, File I/O export, offline-first.

---

### 🗺️ Campus Map (`/map`)
| Method | Path | Description |
|--------|------|-------------|
| GET | `/map/pois` | All campus POIs (filter by category) |
| GET | `/map/pois/{id}` | Single POI details |
| POST | `/map/pois` | **[Admin]** Add a POI |
| PUT | `/map/pois/{id}` | **[Admin]** Update a POI |
| DELETE | `/map/pois/{id}` | **[Admin]** Remove a POI |

Categories: `Academic` · `Food` · `Library` · `Housing`

> **OS Concept:** Location/GPS — client overlays coordinates on OpenStreetMap.

---

## 🏗️ Project Structure

```
backend/
├── main.py                         # App factory, router registration, Swagger tags
├── seed.py                         # Demo data seeder
├── requirements.txt
├── orbit.db                        # SQLite DB (auto-created on first run)
├── uploads/
│   └── events/                     # Uploaded photo notes
├── core/
│   ├── database.py                 # SQLAlchemy engine + session + Base
│   └── security.py                 # JWT utils, password hashing, auth dependencies
├── models/
│   ├── __init__.py                 # Registers all models for SQLAlchemy
│   ├── user_model.py
│   ├── announcement_model.py
│   ├── read_receipt_model.py
│   ├── event_model.py
│   ├── event_registration_model.py
│   ├── feed_post_model.py
│   ├── notification_model.py
│   ├── timetable_model.py
│   ├── campus_poi_model.py
│   └── photo_note_model.py
├── schemas/
│   ├── user_schema.py
│   ├── announcement_schema.py
│   ├── event_schema.py
│   └── misc_schemas.py             # Feed, Notification, Timetable, POI, PhotoNote
└── controllers/
    ├── auth_controller.py
    ├── user_controller.py
    ├── announcement_controller.py
    ├── event_controller.py
    ├── feed_controller.py
    ├── notification_controller.py
    ├── timetable_controller.py
    └── map_controller.py
```

---

## 🔒 Authentication

All endpoints except `POST /auth/register` and `POST /auth/login` require:

```
Authorization: Bearer <token>
```

Admin-only endpoints additionally check `user.is_staff == True` and return **403** otherwise.

---

## 📱 Mobile OS Concepts Mapping

| OS Concept | Backend Evidence |
|------------|-----------------|
| **Security / Auth** | JWT + bcrypt, biometric token validation |
| **Secure Storage** | Tokens issued here, stored in `FlutterSecureStorage` on device |
| **Networking** | All 48 REST endpoints (GET/POST/PUT/DELETE) |
| **Offline Caching** | Clients cache list responses; export endpoint provides JSON file |
| **File I/O** | `GET /timetable/export` → downloadable JSON |
| **Camera / Gallery** | `POST /events/{id}/photos` → multipart image upload |
| **Location / GPS** | `GET /map/pois` → lat/lng coordinates overlaid on live map |
| **Notifications** | `POST /notifications/send` → targeted push with deep-link route |
| **Background Refresh** | `/announcements` and `/feed` called by Flutter background task |
| **App Lifecycle** | Endpoints designed to be called on `resume` to refresh stale cache |

---

## 🗄️ Database

Uses **SQLite** (file `orbit.db`) for development.  
To switch to **PostgreSQL** for production, change one line in `core/database.py`:

```python
SQLALCHEMY_DATABASE_URL = "postgresql://user:password@localhost/orbit"
```

And install `psycopg2-binary`.