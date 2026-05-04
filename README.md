# Orbit — SmartCampus Companion 🚀

Orbit is a premium, feature-rich mobile application designed to unify the university experience for students and staff. Built with **Flutter** and backed by a **FastAPI** server, it serves as a master demonstration of **Mobile Operating Systems** concepts.

---

## 📱 Mobile OS Concepts & Implementation

This project implements core hardware and system-level integrations required in modern mobile development:

| OS Concept | Tech Used | Feature Implementation |
| :--- | :--- | :--- |
| **Biometric Security** | `local_auth` | **Fingerprint Login**: Secure hardware-level authentication before accessing the dashboard. |
| **Geolocation & GPS** | `geolocator` | **Live Map Tracking**: Real-time GPS sensing with a pulsing user marker on the campus map. |
| **System Permissions** | `PermissionHandler` | **Dynamic Requests**: Graceful runtime handling of Camera, Location, and Storage permissions. |
| **Hardware Access** | `image_picker` | **Media Upload**: Direct access to System Camera & File Gallery for admin publishing. |
| **Secure Persistence** | `flutter_secure_storage` | **Token Sandboxing**: Encrypted storage of JWT sessions, isolated from other apps. |
| **Background Refresh** | `Dio` / `Async` | **Non-blocking I/O**: Fetching announcements and feed data without freezing the UI. |

---

## 🛠️ Complete Feature Set

### 1. Unified Dashboard
- **Greeting System**: Personalized welcome messages based on logged-in user data.
- **Dynamic Access Control**: Automatically detects `isStaff` role to display the exclusive **Admin Panel**.
- **Contextual Cards**: Real-time count of today's classes and unread alerts.

### 2. Admin Command Center (Staff)
- **High-Priority Alerts**: Publish urgent announcements to the entire campus.
- **Event Creator**: Organize workshops or seminars.
- **Hardware Integration**: Use the **Camera** to capture flyers or **File Picker** to upload digital event posters.

### 3. Interactive Campus Map
- **GPS Localization**: "Find Me" feature that re-centers the map on your exact coordinates.
- **Points of Interest (POIs)**: Visual markers for Libraries, Labs, and Cafeterias.
- **OpenStreetMap Integration**: No-latency map tiles via `latlong2`.

### 4. Campus Social Feed
- **Global Feed**: A real-time stream of updates from student societies.
- **Pinned Posts**: Important notices stay at the top.
- **Seen Counters**: Track engagement on different posts.

### 5. Smart Schedule (Timetable)
- **Weekly Planner**: Visual class schedule items with custom color coding.
- **Subject Details**: Instructor names and room locations for every slot.

---

## 🏗️ Technical Architecture

- **Frontend**: Flutter (Clean architecture with Riverpod for state management).
- **Backend**: FastAPI (Python) using a RESTful architecture.
- **Database**: SQLite (SQLAlchemy) for robust local/server data handling.
- **Networking**: `Dio` client with interceptors for automatic JWT header attachment.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.3.0+)
- Python 3.10+
- Android Emulator / Physical Device

### 1. Setup the Backend
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python seed.py            # IMPORTANT: Populates demo users & data
uvicorn main:app --host 0.0.0.0 --port 8000
```

### 2. Setup the Frontend
```bash
cd frontend
# If using a physical device, bridge the ports:
adb reverse tcp:8000 tcp:8000 
flutter pub get
flutter run
```

---

## 👥 Demo Credentials

Use these accounts to test the different permission levels:

| User Role | Email | Password | Exclusive Features |
| :--- | :--- | :--- | :--- |
| **Staff Admin** | `admin@university.edu` | `Admin123!` | Camera Access, File Uploads, Admin Panel |
| **Student** | `ibaa@university.edu` | `Student123!` | Personal Feed, Timetable, Register for Events |

