"""
seed.py — Populate the Orbit database with realistic demo data.
Run: python seed.py
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))

from datetime import datetime, timedelta
from core.database import SessionLocal, engine, Base
import models  # registers all models

from models.user_model import UserModel
from models.announcement_model import AnnouncementModel
from models.event_model import EventModel
from models.event_registration_model import EventRegistrationModel
from models.feed_post_model import FeedPostModel
from models.notification_model import NotificationModel
from models.timetable_model import TimetableEntryModel
from models.campus_poi_model import CampusPOIModel
from core.security import hash_password

Base.metadata.create_all(bind=engine)
db = SessionLocal()

# ─── Users ────────────────────────────────────────────────────────────────────
admin = UserModel(
    full_name="Admin Staff",
    email="admin@university.edu",
    student_id=None,
    hashed_password=hash_password("Admin123!"),
    avatar_initials="AS",
    department="IT Services",
    is_staff=True,
)
student = UserModel(
    full_name="Ibaa Lamouri",
    email="ibaa@university.edu",
    student_id="882910",
    hashed_password=hash_password("Student123!"),
    avatar_initials="IL",
    department="Computer Science",
    is_staff=False,
)
db.add_all([admin, student])
db.commit()

# ─── Announcements ────────────────────────────────────────────────────────────
announcements = [
    AnnouncementModel(
        title="Midterm Examination Schedule Released",
        body="The Office of the Registrar has officially released the schedule for the upcoming Midterm Examinations for the Fall 2024 Semester. Students are advised to review their specific course timings.",
        category="Academic",
        target_audience="All",
        is_published=True,
        send_push_notification=True,
        author_id=admin.id,
    ),
    AnnouncementModel(
        title="System Maintenance: Library Portal Offline",
        body="The main digital archives and library booking portal will undergo emergency maintenance from 2 AM to 6 AM on Saturday.",
        category="Urgent",
        target_audience="All",
        is_published=True,
        send_push_notification=True,
        author_id=admin.id,
    ),
    AnnouncementModel(
        title="Spring Career Fair: Registration Open",
        body="Join over 50 leading companies at the Great Hall next Tuesday. Early bird registration closes Friday.",
        category="Event",
        target_audience="All",
        is_published=True,
        send_push_notification=False,
        author_id=admin.id,
    ),
    AnnouncementModel(
        title="Campus Shuttle Schedule Update",
        body="Due to roadwork on College Avenue, the Green Line shuttle will experience delays of up to 15 minutes.",
        category="Admin",
        target_audience="All",
        is_published=True,
        send_push_notification=False,
        author_id=admin.id,
    ),
]
db.add_all(announcements)
db.commit()

# ─── Events ───────────────────────────────────────────────────────────────────
now = datetime.utcnow()
events = [
    EventModel(
        title="Tech Fair 2024",
        description="Join us for the largest student-led technology showcase of the year. Explore groundbreaking projects from Computer Science and Engineering departments.",
        location="Main Courtyard",
        event_date=now + timedelta(days=5, hours=10),
        end_time=now + timedelta(days=5, hours=18),
        capacity=500,
        event_type="Workshop",
        is_published=True,
        author_id=admin.id,
    ),
    EventModel(
        title="UX Research Masterclass",
        description="A hands-on workshop covering usability testing, user interviews, and prototyping.",
        location="Digital Media Lab",
        event_date=now + timedelta(days=2, hours=9),
        capacity=100,
        event_type="Workshop",
        is_published=True,
        author_id=admin.id,
    ),
    EventModel(
        title="The Future of AI in Academia",
        description="Guest seminar with Professor M. Zhao on AI's transformative role in higher education.",
        location="Great Hall Auditorium",
        event_date=now + timedelta(days=4, hours=14, minutes=30),
        capacity=300,
        event_type="Seminar",
        is_published=True,
        author_id=admin.id,
    ),
    EventModel(
        title="Inter-Departmental Soccer Cup",
        description="Annual soccer tournament. Form your team and register before Nov 1.",
        location="Athletic Field North",
        event_date=now + timedelta(days=20),
        capacity=200,
        event_type="Sport",
        is_published=False,
        is_draft=True,
        author_id=admin.id,
    ),
    EventModel(
        title="Annual Innovation Summit",
        description="A full-day summit showcasing student innovations and entrepreneurial projects.",
        location="Founders Hall",
        event_date=now + timedelta(days=7),
        capacity=400,
        event_type="Seminar",
        is_published=True,
        author_id=admin.id,
    ),
]
db.add_all(events)
db.commit()

# Register student for first event
reg = EventRegistrationModel(event_id=events[0].id, user_id=student.id)
db.add(reg)
db.commit()

# ─── Feed Posts ───────────────────────────────────────────────────────────────
feed_posts = [
    FeedPostModel(
        tag="ANNOUNCEMENT",
        title="Library hours extended for Finals Week",
        body="Good news! Starting Monday, the Main Library will be open until midnight every weekday during finals week.",
        author_label="Student Council",
        is_pinned=True,
        seen_count=1240,
        author_id=admin.id,
    ),
    FeedPostModel(
        tag="CAMPUS EVENT",
        title="Tech Fair 2024: Innovation Lab",
        body="Join 50+ tech startups in the main courtyard. Free workshops on AI and Machine Learning all day.",
        author_label="Tech Society",
        is_pinned=False,
        seen_count=882,
        author_id=admin.id,
    ),
    FeedPostModel(
        tag="CLUB NEWS",
        title="Weekly Sustainability Meeting",
        body="Help us plan the campus garden expansion. New members are welcome — no experience needed!",
        author_label="Green Campus Club",
        is_pinned=False,
        seen_count=310,
        author_id=admin.id,
    ),
    FeedPostModel(
        tag="REMINDER",
        title="Course Registration Deadline",
        body="Final call for Spring 2025 registration. Ensure your credits are locked in before Friday 11:59 PM.",
        author_label="Registrar's Office",
        is_pinned=False,
        seen_count=4120,
        author_id=admin.id,
    ),
]
db.add_all(feed_posts)
db.commit()

# ─── Notifications ────────────────────────────────────────────────────────────
notifications = [
    NotificationModel(
        user_id=student.id,
        title="Registration Deadline",
        body="The registration window for Semester 2 Advanced Economics closes in 4 hours.",
        icon_type="event",
        is_read=False,
        deep_link_route="/announcements",
    ),
    NotificationModel(
        user_id=student.id,
        title="Security Alert",
        body="A login attempt was detected from a new device in London, UK.",
        icon_type="alert",
        is_read=False,
    ),
    NotificationModel(
        user_id=student.id,
        title="Package Arrival",
        body="Your textbook order #8291 has been delivered to the Student Union locker.",
        icon_type="package",
        is_read=True,
        created_at=datetime.utcnow() - timedelta(hours=20),
    ),
    NotificationModel(
        user_id=student.id,
        title="Social Mixer Confirmed",
        body="The Annual Tech Society Mixer has been moved to Hall B. See you there!",
        icon_type="info",
        is_read=True,
        created_at=datetime.utcnow() - timedelta(days=3),
    ),
]
db.add_all(notifications)
db.commit()

# ─── Timetable ────────────────────────────────────────────────────────────────
schedule = [
    TimetableEntryModel(user_id=student.id, subject="Advanced Algorithms", instructor="Dr. Sarah Chen", location="Lecture Hall 4B", day_of_week="Mon", start_time="09:00", end_time="10:30", color_hex="#0D6E53", semester="Fall 2024"),
    TimetableEntryModel(user_id=student.id, subject="Database Systems", instructor="Prof. James Wilson", location="Lab 202", day_of_week="Mon", start_time="11:00", end_time="12:30", color_hex="#1E659A", semester="Fall 2024"),
    TimetableEntryModel(user_id=student.id, subject="Advanced Macroeconomics", instructor="Dr. Alistair Vance", location="Room 402 • Hall A", day_of_week="Tue", start_time="09:00", end_time="10:30", color_hex="#0D6E53", semester="Fall 2024"),
    TimetableEntryModel(user_id=student.id, subject="Digital Ethics & Law", instructor="Prof. Sarah Jenkins", location="Innovation Lab • Floor 2", day_of_week="Tue", start_time="11:15", end_time="12:45", color_hex="#1E659A", semester="Fall 2024"),
    TimetableEntryModel(user_id=student.id, subject="Research Seminar", instructor="Dr. M. Zhao", location="Main Library • Seminar Room C", day_of_week="Tue", start_time="14:00", end_time="15:30", color_hex="#757575", semester="Fall 2024"),
    TimetableEntryModel(user_id=student.id, subject="Software Engineering", instructor="Dr. Lena Park", location="CS Building Room 110", day_of_week="Wed", start_time="09:00", end_time="10:30", color_hex="#0D6E53", semester="Fall 2024"),
    TimetableEntryModel(user_id=student.id, subject="Hackathon Prep", instructor="TBD", location="Innovation Hub", day_of_week="Wed", start_time="14:00", end_time="15:30", color_hex="#B71C1C", semester="Fall 2024"),
]
db.add_all(schedule)
db.commit()

# ─── Campus POIs ──────────────────────────────────────────────────────────────
pois = [
    CampusPOIModel(name="Science Library", category="Library", description="Main academic library with 24/7 study zones.", latitude=36.7540, longitude=3.0590, distance_meters=200, opening_hours="Open until 8PM", status="Open", icon_type="library_books"),
    CampusPOIModel(name="Main Hall", category="Academic", description="Central lecture hall complex.", latitude=36.7538, longitude=3.0588, distance_meters=0, status="Open", icon_type="school"),
    CampusPOIModel(name="Food Court", category="Food", description="Multiple dining options and campus café.", latitude=36.7535, longitude=3.0580, distance_meters=450, opening_hours="7AM - 9PM", status="Busy", icon_type="restaurant"),
    CampusPOIModel(name="Student Union", category="Academic", description="Student services, clubs, and events hub.", latitude=36.7542, longitude=3.0595, distance_meters=300, status="Open", icon_type="people"),
    CampusPOIModel(name="Athletic Field North", category="Housing", description="Sports fields for football and athletics.", latitude=36.7520, longitude=3.0575, distance_meters=800, status="Open", icon_type="sports"),
    CampusPOIModel(name="Innovation Lab", category="Academic", description="Maker space with 3D printers and electronics workstations.", latitude=36.7545, longitude=3.0600, distance_meters=350, opening_hours="9AM - 10PM", status="Open", icon_type="science"),
]
db.add_all(pois)
db.commit()

db.close()
print("✅ Database seeded successfully!")
print("   Admin:   admin@university.edu  /  Admin123!")
print("   Student: ibaa@university.edu   /  Student123!")