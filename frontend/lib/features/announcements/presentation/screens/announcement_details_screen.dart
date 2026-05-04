import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/announcement_provider.dart';
import '../../data/models/announcement_model.dart';

class AnnouncementDetailsScreen extends ConsumerWidget {
  const AnnouncementDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementId = ModalRoute.of(context)?.settings.arguments as int?;
    
    if (announcementId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Invalid Announcement ID')),
      );
    }

    final announcementAsync = ref.watch(announcementDetailProvider(announcementId));

    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F8),
      body: announcementAsync.when(
        data: (announcement) => _buildContent(context, announcement),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF0D6E53)),
              SizedBox(height: 16),
              Text('Fetching announcement details...', style: TextStyle(color: Color(0xFF0D6E53))),
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Unable to load details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => ref.refresh(announcementDetailProvider(announcementId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6E53),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0D6E53)),
            label: const Text(
              'Back to Feed',
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

  Widget _buildContent(BuildContext context, AnnouncementModel announcement) {
    Color categoryColor;
    IconData categoryIcon;
    
    final String category = announcement.category;
    
    switch (category) {
      case 'Urgent':
        categoryColor = Colors.red;
        categoryIcon = Icons.emergency_outlined;
        break;
      case 'Academic':
        categoryColor = const Color(0xFF0D6E53);
        categoryIcon = Icons.school_outlined;
        break;
      case 'Event':
        categoryColor = Colors.blue;
        categoryIcon = Icons.event_note_outlined;
        break;
      default:
        categoryColor = Colors.orange;
        categoryIcon = Icons.campaign_outlined;
    }

    return Stack(
      children: [
        // Top Background with Icon
        Container(
          height: 220,
          width: double.infinity,
          color: const Color(0xFF0D6E53).withValues(alpha: 0.1),
          child: Center(
            child: Icon(
              categoryIcon,
              size: 80,
              color: const Color(0xFF0D6E53).withValues(alpha: 0.2),
            ),
          ),
        ),
        
        // Header Controls
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF0D6E53), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0D6E53),
                    letterSpacing: 1.2,
                  ),
                ),
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.share, color: Color(0xFF0D6E53), size: 18),
                ),
              ],
            ),
          ),
        ),

        // Main Sheet
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 180),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: categoryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    announcement.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A1A),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('EEEE, MMM dd • hh:mm a').format(announcement.createdAt),
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'MESSAGE',
                    style: TextStyle(
                      color: Color(0xFF757575),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    announcement.body,
                    style: const TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  if (category == 'Event')
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.event, color: Colors.blue, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Campus Event',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'This announcement is linked to an official campus event. Please check the Events section for registration and venue details.',
                            style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/events'),
                            child: const Text('Go to Events', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
