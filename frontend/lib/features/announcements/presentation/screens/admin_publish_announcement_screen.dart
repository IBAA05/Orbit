import 'package:flutter/material.dart';

class AdminPublishAnnouncementScreen extends StatelessWidget {
  const AdminPublishAnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTabToggle(),
              const SizedBox(height: 24),
              _buildTitleSection(),
              const SizedBox(height: 24),
              _buildFormCard(),
              const SizedBox(height: 16),
              _buildTargetAudienceCard(),
              const SizedBox(height: 16),
              _buildScheduleNotificationCard(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF0D6E53), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('Save as\nDraft', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF0D6E53), fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.send_outlined, color: Colors.white, size: 18),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF0D6E53),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        elevation: 0,
                      ),
                      label: const Text('Publish Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.shield_outlined, color: Color(0xFF0D6E53), size: 24),
            const SizedBox(width: 8),
            const Text(
              'Admin Panel',
              style: TextStyle(
                color: Color(0xFF0D6E53),
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'STAFF',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/announcement_banner.jpg'), // Placeholder
            ),
            const SizedBox(width: 12),
            Icon(Icons.logout, color: Colors.red.shade400, size: 22),
          ],
        )
      ],
    );
  }

  Widget _buildTabToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D6E53),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: const Center(
                child: Text('Announcements', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Events', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New Announcement',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Broadcast important information to the campus\ncommunity.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('HEADLINE'),
              Text('0/80', style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          _buildTextField('Enter a descriptive title...'),
          const SizedBox(height: 20),
          _buildLabel('CATEGORY'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: [
              _buildOutlinedChip('Academic', isActive: true),
              _buildOutlinedChip('Urgent'),
              _buildOutlinedChip('Event'),
              _buildOutlinedChip('Admin'),
              _buildOutlinedChip('Other'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('MESSAGE BODY'),
              Text('0/500', style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Write your announcement here...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetAudienceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Target Audience', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
              const SizedBox(height: 4),
              Text('Who should receive this update?', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: const Text('All', style: TextStyle(color: Color(0xFF0D6E53), fontWeight: FontWeight.w900, fontSize: 11)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Custom', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w800, fontSize: 11)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildScheduleNotificationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Schedule Publication', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Pick a future date or publish now.', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
              Switch(
                value: false,
                onChanged: (val) {},
                activeColor: const Color(0xFF0D6E53),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
               Expanded(
                child: _buildTextField('Oct 24, 2023', icon: Icons.calendar_today, iconRight: true),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField('09:00 AM', icon: Icons.access_time, iconRight: true),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: const Color(0xFFEAF5F0),
               borderRadius: BorderRadius.circular(12),
             ),
             child: Row(
               children: [
                 Container(
                   padding: const EdgeInsets.all(2),
                   decoration: BoxDecoration(color: const Color(0xFF0D6E53), borderRadius: BorderRadius.circular(4)),
                   child: const Icon(Icons.check, color: Colors.white, size: 16),
                 ),
                 const SizedBox(width: 12),
                 const Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('Send push notification', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0D6E53), fontSize: 13)),
                     SizedBox(height: 2),
                     Text('Alert users immediately on their mobile devices', style: TextStyle(color: Color(0xFF2E8B57), fontSize: 10)),
                   ],
                 )
               ],
             ),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Color(0xFF757575),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField(String hint, {IconData? icon, bool iconRight = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: !iconRight && icon != null ? Icon(icon, color: Colors.grey.shade400, size: 18) : null,
          suffixIcon: iconRight && icon != null ? Icon(icon, color: Colors.grey.shade400, size: 18) : null,
        ),
      ),
    );
  }

  Widget _buildOutlinedChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEAF5F0) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? const Color(0xFF0D6E53) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? const Color(0xFF0D6E53) : Colors.grey.shade600,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.grid_view_rounded, false),
            // Middle action button container matching the screenshot layout where Megaphone is active
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0D6E53),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.campaign_outlined, color: Colors.white, size: 22),
            ),
            _buildNavItem(Icons.calendar_today_outlined, false),
            _buildNavItem(Icons.settings_outlined, false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Icon(
      icon,
      color: isActive ? const Color(0xFF0D6E53) : Colors.grey.shade400,
      size: 26,
    );
  }
}
