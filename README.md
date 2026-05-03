🔐 Auth (/auth)
Frontend Screen	Action	Backend Endpoint	Status
login_screen.dart	Enter email + password → Sign In	POST /auth/login	✅
signup_screen.dart	Fill form → Create Account	POST /auth/register	✅
biometrics_screen.dart	Use fingerprint	POST /auth/biometric-login	✅
Any screen	Logout button	POST /auth/logout	✅
📢 Announcements (/announcements)
Frontend Screen	Action	Backend Endpoint	Status
announcements_screen.dart	Show list of announcements	GET /announcements/	✅
announcement_details_screen.dart	Open one announcement	GET /announcements/{id}	✅
announcement_details_screen.dart	Mark as read (badge disappears)	POST /announcements/{id}/read	✅
admin_publish_announcement_screen.dart	Admin creates new announcement	POST /announcements/	✅
🎉 Events (/events)
Frontend Screen	Action	Backend Endpoint	Status
events_screen.dart	Show list of events	GET /events/	✅
event_details_screen.dart	Open event details	GET /events/{id}	✅
event_details_screen.dart	Register for event	POST /events/{id}/register	✅
event_details_screen.dart	Cancel registration	DELETE /events/{id}/register	✅
event_details_screen.dart	Upload a photo note (camera)	POST /events/{id}/photos	✅
admin_event_management_screen.dart	Admin creates/edits event	POST /events/	✅
⚡ Campus Feed (/feed)
Frontend Screen	Action	Backend Endpoint	Status
campus_feed_screen.dart	Load all posts	GET /feed/	✅
campus_feed_screen.dart	Open a post (auto increments "seen")	GET /feed/{id}	✅
🔔 Notifications (/notifications)
Frontend Screen	Action	Backend Endpoint	Status
notifications_screen.dart	Load my notifications	GET /notifications/	✅
notifications_screen.dart	Tap to mark as read	PUT /notifications/{id}/read	✅
notifications_screen.dart	"Mark all read" button	PUT /notifications/read-all	✅
notifications_screen.dart	Swipe to delete	DELETE /notifications/{id}	✅
📅 Timetable (/timetable)
Frontend Screen	Action	Backend Endpoint	Status
schedule_screen.dart	Load my weekly schedule	GET /timetable/	✅
schedule_screen.dart	Filter by day (Mon, Tue...)	GET /timetable/?day=Mon	✅
schedule_screen.dart	Export schedule to JSON file	GET /timetable/export	✅
🗺️ Campus Map (/map)
Frontend Screen	Action	Backend Endpoint	Status
campus_map_screen.dart	Load all campus POIs (pins on map)	GET /map/pois	✅
campus_map_screen.dart	Tap a pin to see POI details	GET /map/pois/{id}	✅
👤 Profile (/users)
Frontend Screen	Action	Backend Endpoint	Status
profile_screen.dart	Load my name, dept, initials	GET /users/me	✅
profile_screen.dart	Toggle dark mode / notifications	PUT /users/me	✅
profile_screen.dart	Change password	PUT /users/me/password	✅
profile_screen.dart	Upload a profile picture	POST /users/me/avatar	❌ Missing
Summary
You have ~25 fully linkable features right now. The only truly missing backend piece is the profile picture upload endpoint which we planned to add later.