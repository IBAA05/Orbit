import 'package:flutter/material.dart';
import 'package:orbit/core/routing/app_routes.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Announcements',
          style: TextStyle(
            color: Color(0xFF0D6E53),
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF0D6E53)),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Category Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildCategoryPill('All', isSelected: true, selectedColor: const Color(0xFF0D6E53), selectedTextColor: Colors.white),
                  const SizedBox(width: 12),
                  _buildCategoryPill('Academic', isSelected: false, baseColor: const Color(0xFFDCE6FF), textColor: const Color(0xFF1E3A8A)),
                  const SizedBox(width: 12),
                  _buildCategoryPill('Events', isSelected: false, onTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.events);
                  }),
                  const SizedBox(width: 12),
                  _buildCategoryPill('Urgent', isSelected: false),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Announcement Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _buildAnnouncementCard(
                    context: context,
                    tag: 'URGENT',
                    tagColor: Colors.white,
                    tagBackground: const Color(0xFFD32F2F),
                    time: '15m ago',
                    title: 'System Maintenance: Library Portal Offline',
                    body: 'The main digital archives and library booking portal will undergo emergen...',
                    author: 'IT Services Dept.',
                  ),
                  const SizedBox(height: 16),
                  _buildAnnouncementCard(
                    context: context,
                    tag: 'ACADEMIC',
                    tagColor: Colors.white,
                    tagBackground: const Color(0xFF2E7D32),
                    time: '2h ago',
                    title: 'Final Thesis Submission Guidelines 2024',
                    body: 'New formatting requirements for digital thesis submission have been uploade...',
                    author: 'Dr. Sarah Jenkins',
                  ),
                  const SizedBox(height: 16),
                  _buildAnnouncementCard(
                    context: context,
                    tag: 'EVENTS',
                    tagColor: Colors.white,
                    tagBackground: const Color(0xFF1976D2),
                    time: '5h ago',
                    title: 'Spring Career Fair: Registration Open',
                    body: 'Join over 50 leading companies at the Great Hall next Tuesday. Early bird...',
                    author: 'Career Center',
                  ),
                  const SizedBox(height: 16),
                  _buildAnnouncementCard(
                    context: context,
                    tag: 'ADMIN',
                    tagColor: const Color(0xFF424242),
                    tagBackground: const Color(0xFFE0E0E0),
                    time: 'Yesterday',
                    title: 'Campus Shuttle Schedule Update',
                    body: 'Due to roadwork on College Avenue, the Green Line shuttle will experience...',
                    author: 'Facilities Office',
                  ),
                  const SizedBox(height: 120), // Spacer for bottom floating nav
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(context, icon: Icons.home_outlined, isSelected: false, route: AppRoutes.home),
                _buildNavItem(context, icon: Icons.calendar_month, isSelected: true, route: AppRoutes.announcements),
                _buildNavItem(context, icon: Icons.bolt_outlined, isSelected: false, route: AppRoutes.feed),
                _buildNavItem(context, icon: Icons.map_outlined, isSelected: false, route: AppRoutes.map),
                _buildNavItem(context, icon: Icons.person_outline, isSelected: false, route: AppRoutes.profile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPill(
    String text, {
    required bool isSelected,
    Color baseColor = const Color(0xFFEEEEEE),
    Color textColor = const Color(0xFF666666),
    Color? selectedColor,
    Color? selectedTextColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? (selectedColor ?? Colors.blue) : baseColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? (selectedTextColor ?? Colors.white) : textColor,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ));
  }

  Widget _buildAnnouncementCard({
    BuildContext? context,
    required String tag,
    required String time,
    required String title,
    required String body,
    required String author,
    required Color tagBackground,
    required Color tagColor,
  }) {
    return GestureDetector(
      onTap: () {
        if (context != null) {
          Navigator.pushNamed(context, AppRoutes.announcementDetails);
        }
      },
      child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagBackground,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFBDBDBD),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                author,
                style: const TextStyle(
                  color: Color(0xFF424242),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildNavItem(BuildContext context, {required IconData icon, required bool isSelected, required String route}) {
    return GestureDetector(
      onTap: () {
        if (!isSelected && route.isNotEmpty) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D6E53) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF757575),
          size: 26,
        ),
      ),
    );
  }
}
