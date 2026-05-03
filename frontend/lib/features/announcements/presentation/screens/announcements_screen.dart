import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/routing/app_routes.dart';
import '../providers/announcement_provider.dart';
import '../../data/models/announcement_model.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final announcementsAsync = ref.watch(announcementListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'ANNOUNCEMENTS',
          style: TextStyle(
            color: Color(0xFF0D6E53),
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D6E53), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFF0D6E53)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildCategoryChip(ref, 'All', isSelected: selectedCategory == null, category: null),
                  _buildCategoryChip(ref, 'Academic', isSelected: selectedCategory == 'Academic', category: 'Academic'),
                  _buildCategoryChip(ref, 'Urgent', isSelected: selectedCategory == 'Urgent', category: 'Urgent'),
                  _buildCategoryChip(ref, 'Events', isSelected: selectedCategory == 'Event', category: 'Event'),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(announcementListProvider.future),
              color: const Color(0xFF0D6E53),
              child: announcementsAsync.when(
                data: (announcements) {
                  if (announcements.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                        const Center(
                          child: Column(
                            children: [
                              Icon(Icons.notifications_off_outlined, size: 48, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No announcements found.', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final announcement = announcements[index];
                      return _buildAnnouncementCard(context, announcement);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF0D6E53))),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 40),
                      const SizedBox(height: 16),
                      const Text('Could not load announcements'),
                      TextButton(onPressed: () => ref.refresh(announcementListProvider), child: const Text('Retry')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(WidgetRef ref, String label, {required bool isSelected, required String? category}) {
    return GestureDetector(
      onTap: () => ref.read(selectedCategoryProvider.notifier).state = category,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D6E53) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF666666),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, AnnouncementModel announcement) {
    Color indicatorColor;
    switch (announcement.category) {
      case 'Urgent': indicatorColor = Colors.red; break;
      case 'Academic': indicatorColor = const Color(0xFF0D6E53); break;
      case 'Event': indicatorColor = Colors.blue; break;
      default: indicatorColor = Colors.orange;
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.announcementDetails, arguments: announcement.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  announcement.category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: indicatorColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('MMM dd').format(announcement.createdAt),
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              announcement.title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A), height: 1.3),
            ),
            const SizedBox(height: 8),
            Text(
              announcement.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
