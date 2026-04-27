import 'package:flutter/material.dart';

class AnnouncementDetailsScreen extends StatelessWidget {
  const AnnouncementDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F8), // Top light blue section
      body: Stack(
        children: [
          // Background Icon centered in top section 
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.campaign, size: 48, color: Colors.white),
              ),
            ),
          ),
          
          // Header Row
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF0D6E53), size: 20),
                    ),
                  ),
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0D6E53),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share, color: Color(0xFF0D6E53), size: 18),
                  ),
                ],
              ),
            ),
          ),

          // Main White Sheet
          Positioned.fill(
            top: 180, // Height from top where white sheet starts
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Pill floating above the sheet
                  Positioned(
                    top: -16,
                    left: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Text(
                        'Academic',
                        style: TextStyle(
                          color: Color(0xFF1E659A),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  
                  // Scrollable Content Content
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Midterm Examination Schedule Released',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A1A1A),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Posted 2 hours ago • by Admin',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Icon Chips Row
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildInfoChip(Icons.category_outlined, 'Academic'),
                                const SizedBox(width: 12),
                                _buildInfoChip(Icons.people_outline, 'All students'),
                                const SizedBox(width: 12),
                                _buildInfoChip(Icons.notifications_outlined, 'Sent'),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          const Divider(color: Color(0xFFEEEEEE)),
                          const SizedBox(height: 24),
                          
                          // Fake Image PDF box (Moved above description)
                          Container(
                            height: 110, // Reduced height
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/announcement_banner.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [Colors.black54, Colors.transparent],
                                      ),
                                    ),
                                    child: const Text(
                                      'View Full PDF Schedule',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          const Text(
                            'DETAILS',
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          const Text(
                            'The Office of the Registrar has officially released the schedule for the upcoming Midterm Examinations for the Fall 2024 Semester. Students are advised to review their specific course timings and venue assignments through the student portal.\n\nPlease note that exams will be conducted strictly according to the published timetable. No rescheduling requests will be entertained except in documented cases of medical emergencies or institutional conflicts.\n\nEnsure you arrive at least 15 minutes prior to the start time with your valid Student ID card. Digital copies of the ID will not be accepted at the examination halls.',
                            style: TextStyle(
                              color: Color(0xFF424242),
                              fontSize: 15,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_circle_outline, color: Color(0xFF0D6E53)),
            label: const Text(
              'Mark as read',
              style: TextStyle(
                color: Color(0xFF0D6E53),
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Color(0xFF0D6E53), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF666666)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }
}
