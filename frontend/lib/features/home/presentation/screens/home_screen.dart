import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit/core/routing/app_routes.dart';
import 'package:orbit/features/auth/presentation/providers/auth_provider.dart';
import 'package:orbit/features/announcements/presentation/providers/announcement_provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final announcementsAsync = ref.watch(announcementListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF0D6E53)),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF0D6E53),
                child: Text(
                  (authState.fullName?.isNotEmpty ?? false) ? authState.fullName![0].toUpperCase() : 'U',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Good morning, ${authState.fullName?.split(' ')[0] ?? 'User'} 👋',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, MMM dd').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E659A),
                ),
              ),
              const SizedBox(height: 24),

              // ADMIN DASHBOARD BUTTON
              if (authState.isStaff)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D6E53), Color(0xFF157053)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D6E53).withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ADMIN PANEL',
                              style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Publish Alerts & Tools',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.adminPublishAnnouncement),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0D6E53),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text('ALERT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.adminAddEvent),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text('EVENT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'CLASSES TODAY',
                      value: '4',
                      borderColor: const Color(0xFF0D6E53),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'NOTIFICATIONS',
                      value: '•',
                      borderColor: const Color(0xFF1E659A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Next Event Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: authState.isStaff ? const Color(0xFF1E659A) : const Color(0xFF0D6E53),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEXT EVENT',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Hackathon Prep',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '14:00 PM',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Today's Schedule Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Today's Schedule",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/schedule');
                    },
                    child: const Text(
                      'View Calendar',
                      style: TextStyle(
                        color: Color(0xFF1E659A),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildScheduleCard(
                time: '09:00 - 10:30',
                title: 'Advanced Algorithms',
                subtitle: 'Lecture Hall 4B • Dr. Sarah Chen',
                borderColor: const Color(0xFF0D6E53),
                icon: Icons.book_outlined,
              ),
              const SizedBox(height: 12),
              _buildScheduleCard(
                time: '11:00 - 12:30',
                title: 'Database Systems',
                subtitle: 'Lab 202 • Prof. James Wilson',
                borderColor: const Color(0xFF1E659A),
                icon: Icons.storage_outlined,
              ),
              const SizedBox(height: 32),

              // Latest Announcements Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Latest Announcements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.announcements),
                    child: const Text('See All', style: TextStyle(color: Color(0xFF0D6E53))),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // REAL Announcements List
              announcementsAsync.when(
                data: (list) {
                  final recent = list.take(3).toList();
                  if (recent.isEmpty) {
                    return const Center(child: Text('No announcements yet.'));
                  }
                  return Column(
                    children: recent.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildRealAnnouncementCard(context, a),
                    )).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Text('Error loading feed: $e'),
              ),

              const SizedBox(height: 120),
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
                _buildNavItem(context, icon: Icons.home_filled, isSelected: true, route: AppRoutes.home),
                _buildNavItem(context, icon: Icons.calendar_today_outlined, isSelected: false, route: AppRoutes.announcements),
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

  Widget _buildRealAnnouncementCard(BuildContext context, dynamic a) {
    Color tagColor;
    Color tagBg;
    
    switch (a.category) {
      case 'Urgent':
        tagColor = Colors.red;
        tagBg = Colors.red.withValues(alpha: 0.1);
        break;
      case 'Academic':
        tagColor = const Color(0xFF0D6E53);
        tagBg = const Color(0xFF0D6E53).withValues(alpha: 0.1);
        break;
      default:
        tagColor = Colors.blue;
        tagBg = Colors.blue.withValues(alpha: 0.1);
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.announcementDetails, arguments: a.id),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    a.category.toUpperCase(),
                    style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMM dd').format(a.createdAt),
                  style: const TextStyle(color: Color(0xFF757575), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              a.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            Text(
              a.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666), height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required String value, required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF666666), letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A), letterSpacing: -1)),
        ],
      ),
    );
  }

  Widget _buildScheduleCard({required String time, required String title, required String subtitle, required Color borderColor, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF757575))),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF666666))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFFF5F5F5), shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: const Color(0xFF0D6E53)),
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
        decoration: BoxDecoration(color: isSelected ? const Color(0xFF0D6E53) : Colors.transparent, shape: BoxShape.circle),
        child: Icon(icon, color: isSelected ? Colors.white : const Color(0xFF757575), size: 26),
      ),
    );
  }
}
