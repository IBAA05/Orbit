import 'package:flutter/material.dart';
import '../../../../core/routing/app_routes.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC), // Very light grey base
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Center(
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        title: const Text(
          'MY SCHEDULE',
          style: TextStyle(
            color: Color(0xFF0D6E53),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Color(0xFF0D6E53)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF0D6E53)),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Day Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildDayPill('Mon', isSelected: true),
                const SizedBox(width: 12),
                _buildDayPill('Tue', isSelected: false),
                const SizedBox(width: 12),
                _buildDayPill('Wed', isSelected: false),
                const SizedBox(width: 12),
                _buildDayPill('Thu', isSelected: false),
                const SizedBox(width: 12),
                _buildDayPill('Fri', isSelected: false),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Timeline and Schedule items
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildTimelineCard(
                    time: '09:00',
                    endTime: '10:30 AM',
                    title: 'Advanced\nMacroeconomics',
                    location: 'Room 402 • Hall A',
                    person: 'Dr. Alistair Vance',
                    cardLineColor: const Color(0xFF0D6E53),
                    locationIcon: Icons.door_front_door_outlined,
                  ),
                  _buildTimelineCard(
                    time: '11:15',
                    endTime: '12:45 PM',
                    title: 'Digital Ethics & Law',
                    location: 'Innovation Lab • Floor 2',
                    person: 'Prof. Sarah Jenkins',
                    cardLineColor: const Color(0xFF1E659A), // Blue
                    locationIcon: Icons.business_outlined, // Building icon
                  ),
                  _buildTimelineCard(
                    time: '14:00',
                    endTime: '03:30 PM',
                    title: 'Research Seminar',
                    location: 'Main Library • Seminar Room\nC',
                    person: 'Guest Lecturer: Dr. M. Zhao',
                    cardLineColor: Colors.grey.shade400,
                    backgroundColor: const Color(0xFFF3F4F6), // Greyish bg
                    locationIcon: Icons.location_on_outlined,
                    isLast: true,
                  ),
                  const SizedBox(height: 80), // Fab spacing
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D6E53),
        onPressed: () {},
        shape: const CircleBorder(),
        child: const Icon(Icons.alarm, color: Colors.white),
      ),
    );
  }

  Widget _buildDayPill(String day, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0D6E53) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF424242),
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildTimelineCard({
    required String time,
    required String endTime,
    required String title,
    required String location,
    required String person,
    required Color cardLineColor,
    required IconData locationIcon,
    Color backgroundColor = Colors.white,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Column
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 12), // Align time strictly with top of card content
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF0D6E53),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                Text(
                  endTime,
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 10,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18.0, top: 4),
                      child: VerticalDivider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Card Component
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(color: cardLineColor, width: 4),
                ),
                boxShadow: backgroundColor == Colors.white
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A),
                              height: 1.2,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.more_vert, color: Colors.grey, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(locationIcon, size: 16, color: const Color(0xFF666666)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF424242),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.person_outline, size: 16, color: Color(0xFF666666)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            person,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF424242),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
