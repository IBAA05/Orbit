import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back, color: Color(0xFF0D6E53), size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Orbit',
                        style: TextStyle(
                          color: Color(0xFF0D6E53),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F5E9),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'MARK ALL READ',
                      style: TextStyle(
                        color: Color(0xFF0D6E53),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Stay updated with your latest campus activities and deadlines.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    _buildSectionHeader('TODAY'),
                    const SizedBox(height: 16),
                    _buildNotificationCard(
                      icon: Icons.calendar_today_outlined,
                      iconColor: const Color(0xFF0D6E53),
                      bgColor: const Color(0xFFE8F5E9),
                      title: 'Registration Deadline',
                      body: 'The registration window for Semester 2 Advanced Economics closes in 4 hours.',
                      time: '10:45 AM',
                      isNew: true,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationCard(
                      icon: Icons.priority_high,
                      iconColor: const Color(0xFFD32F2F),
                      bgColor: const Color(0xFFFFEBEE),
                      title: 'Security Alert',
                      body: 'A login attempt was detected from a new device in London, UK.',
                      time: '9:12 AM',
                      isNew: true,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationCard(
                      icon: Icons.notifications_none_outlined,
                      iconColor: const Color(0xFF1E659A),
                      bgColor: const Color(0xFFE3F2FD),
                      title: 'Package Arrival',
                      body: 'Your textbook order #8291 has been delivered to the Student Union locker.',
                      time: 'Yesterday, 4:30 PM',
                      isNew: false,
                    ),
                    
                    const SizedBox(height: 32),
                    _buildSectionHeader('THIS WEEK'),
                    const SizedBox(height: 16),
                    _buildNotificationCard(
                      icon: Icons.event_available_outlined,
                      iconColor: Colors.grey.shade700,
                      bgColor: Colors.grey.shade200,
                      title: 'Social Mixer Confirmed',
                      body: 'The Annual Tech Society Mixer has been moved to Hall B. See you there!',
                      time: 'Oct 24, 2:15 PM',
                      isNew: false,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Colors.grey.shade500,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String body,
    required String time,
    required bool isNew,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isNew ? const Border(left: BorderSide(color: Color(0xFF0D6E53), width: 4)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    if (isNew)
                      const Text(
                        'NEW',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0D6E53),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
