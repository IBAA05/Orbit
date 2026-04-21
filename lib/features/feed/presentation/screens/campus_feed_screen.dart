import 'package:flutter/material.dart';
import '../../../../core/routing/app_routes.dart';

class CampusFeedScreen extends StatelessWidget {
  const CampusFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Orbit',
          style: TextStyle(
            color: Color(0xFF0D6E53),
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF0D6E53)),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Campus Feed',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Stay synchronized with the latest from Student Council.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              
              // Filter Buttons
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D6E53),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('All', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('For me', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Feed Items
              _buildFeedCard(
                tag: 'ANNOUNCEMENT',
                tagBg: const Color(0xFF0D6E53),
                tagColor: Colors.white,
                time: '2m ago',
                title: 'Library hours extended for Finals Week',
                body: 'Good news! Starting Monday, the Main...',
                isHighlight: true,
                avatarContent: const Text('SC', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                avatarBg: const Color(0xFF0D6E53),
              ),
              const SizedBox(height: 16),
              
              _buildFeedCard(
                tag: 'CAMPUS EVENT',
                tagBg: const Color(0xFF90CAF9),
                tagColor: const Color(0xFF0D47A1),
                time: '1h ago',
                title: 'Tech Fair 2024: Innovation Lab',
                body: 'Join 50+ tech startups in the main courtyard. Free workshops on AI and...',
                avatarContent: const Icon(Icons.rocket_launch, size: 16, color: Color(0xFF0D6E53)),
                avatarBg: Colors.grey.shade200,
              ),
              const SizedBox(height: 16),

              _buildFeedCard(
                tag: 'CLUB NEWS',
                tagBg: Colors.grey.shade300,
                tagColor: Colors.grey.shade700,
                time: '4h ago',
                title: 'Weekly Sustainability Meeting',
                body: 'Help us plan the campus garden expansion. New members are welco...',
                avatarContent: const Text('SC', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                avatarBg: const Color(0xFF0D6E53),
                imageUrl: 'https://via.placeholder.com/600x300/4CAF50/FFFFFF?text=Garden+Work',
              ),
              const SizedBox(height: 16),

              _buildFeedCard(
                tag: 'REMINDER',
                tagBg: Colors.grey.shade300,
                tagColor: Colors.grey.shade700,
                time: 'Yesterday',
                title: 'Course Registration Deadline',
                body: 'Final call for Spring 2025 registration. Ensure your credits are locked in...',
                avatarContent: const Text('SC', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                avatarBg: const Color(0xFF0D6E53),
                readMore: true,
                seenBy: 'Seen by 4,120 students',
              ),
              
              const SizedBox(height: 120), // Bottom nav area
            ],
          ),
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
                _buildNavItem(context, icon: Icons.calendar_month, isSelected: false, route: AppRoutes.announcements),
                _buildNavItem(context, icon: Icons.bolt, isSelected: true, route: AppRoutes.feed),
                _buildNavItem(context, icon: Icons.map_outlined, isSelected: false, route: AppRoutes.map),
                _buildNavItem(context, icon: Icons.person_outline, isSelected: false, route: AppRoutes.profile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedCard({
    required String tag,
    required Color tagBg,
    required Color tagColor,
    required String time,
    required String title,
    required String body,
    required Widget avatarContent,
    required Color avatarBg,
    bool isHighlight = false,
    String? imageUrl,
    bool readMore = false,
    String? seenBy,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isHighlight ? const Border(left: BorderSide(color: Color(0xFF0D6E53), width: 4)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: tagColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: avatarBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: avatarContent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                    if (readMore) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Read more',
                        style: TextStyle(
                          color: Color(0xFF0D6E53),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (imageUrl != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                    if (seenBy != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            seenBy,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
