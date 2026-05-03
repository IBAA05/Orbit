import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routing/app_routes.dart';
import '../providers/timetable_provider.dart';
import '../../data/models/timetable_model.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final scheduleAsync = ref.watch(scheduleListProvider);

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
                _buildDayPill(ref, 'Mon', isSelected: selectedDay == 'Mon'),
                const SizedBox(width: 12),
                _buildDayPill(ref, 'Tue', isSelected: selectedDay == 'Tue'),
                const SizedBox(width: 12),
                _buildDayPill(ref, 'Wed', isSelected: selectedDay == 'Wed'),
                const SizedBox(width: 12),
                _buildDayPill(ref, 'Thu', isSelected: selectedDay == 'Thu'),
                const SizedBox(width: 12),
                _buildDayPill(ref, 'Fri', isSelected: selectedDay == 'Fri'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Timeline and Schedule items
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(scheduleListProvider.future),
              color: const Color(0xFF0D6E53),
              child: scheduleAsync.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                        const Center(
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 48, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No classes scheduled for today.', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return _buildTimelineCard(
                        entry: entry,
                        isLast: index == entries.length - 1,
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0D6E53)),
                ),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      const Text('Failed to load schedule'),
                      TextButton(
                        onPressed: () => ref.refresh(scheduleListProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
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

  Widget _buildDayPill(WidgetRef ref, String day, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedDayProvider.notifier).state = day;
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildTimelineCard({
    required TimetableEntryModel entry,
    bool isLast = false,
  }) {
    // Convert hex string to Color object
    Color cardColor;
    try {
      cardColor = Color(int.parse(entry.colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {
      cardColor = const Color(0xFF0D6E53);
    }

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
                const SizedBox(height: 12),
                Text(
                  entry.startTime,
                  style: const TextStyle(
                    color: Color(0xFF0D6E53),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                Text(
                  entry.endTime,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(color: cardColor, width: 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                            entry.subject,
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
                    if (entry.location != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.door_front_door_outlined, size: 16, color: Color(0xFF666666)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.location!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    if (entry.instructor != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.person_outline, size: 16, color: Color(0xFF666666)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.instructor!,
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
