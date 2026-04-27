import 'package:flutter/material.dart';

class AdminEventManagementScreen extends StatelessWidget {
  const AdminEventManagementScreen({super.key});

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
              _buildTitleSection(),
              const SizedBox(height: 24),
              _buildCreateEventCard(),
              const SizedBox(height: 32),
              _buildUpcomingEventsHeader(),
              const SizedBox(height: 16),
              _buildUpcomingEventCard(
                dateStr: 'OCT\n12',
                type: 'WORKSHOP',
                typeColor: const Color(0xFFE8F5E9),
                typeTextColor: const Color(0xFF2E7D32),
                title: 'UX Research Masterclass',
                subtitle: '📍 Digital Media Lab • 09:00 AM',
                progress: 0.84, // 84/100
                progressText: '84/100',
                status: 'OPEN',
                statusColor: const Color(0xFFE8F5E9),
                statusTextColor: const Color(0xFF2E7D32),
              ),
              const SizedBox(height: 16),
              _buildUpcomingEventCard(
                dateStr: 'OCT\n15',
                type: 'SEMINAR',
                typeColor: const Color(0xFFE3F2FD),
                typeTextColor: const Color(0xFF1565C0),
                title: 'The Future of AI in Academia',
                subtitle: '📍 Great Hall Auditorium • 02:30 PM',
                progress: 1.0, // 300/300
                progressText: '300/300',
                status: 'FULL',
                statusColor: Colors.grey.shade300,
                statusTextColor: Colors.black54,
              ),
              const SizedBox(height: 16),
              _buildUpcomingEventCard(
                dateStr: 'NOV\n02',
                dateBg: Colors.grey.shade300,
                type: 'SPORT',
                typeColor: Colors.grey.shade200,
                typeTextColor: Colors.black54,
                title: 'Inter-Departmental Soccer Cup',
                subtitle: '📍 Athletic Field North',
                progress: 0.0, // --/--
                progressText: '--/--',
                status: 'DRAFT',
                statusColor: const Color(0xFFF5F5F5),
                statusTextColor: Colors.grey.shade600,
              ),
              const SizedBox(height: 80),
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

  Widget _buildTitleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Event\nManagement',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A1A),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Schedule and oversee\ncampus reservations',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            children: [
              Text(
                'ACADEMIC\nCYCLE 2024',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1565C0),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateEventCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          // Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D6E53),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Create New Event',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_up, color: Colors.grey.shade400),
              ],
            ),
          ),
          
          Divider(height: 1, color: Colors.grey.shade100),
          
          // Form fields
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('EVENT NAME'),
                const SizedBox(height: 8),
                _buildTextField('e.g. Annual Alumni Symposium'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('DATE'),
                          const SizedBox(height: 8),
                          _buildTextField('mm/dd/yyyy', icon: Icons.calendar_today),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('TIME'),
                          const SizedBox(height: 8),
                          _buildTextField('--:--', icon: Icons.access_time),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabel('LOCATION'),
                const SizedBox(height: 8),
                _buildTextField('Campus Hall B-12', icon: Icons.location_on_outlined),
                const SizedBox(height: 16),
                _buildLabel('COVER IMAGE'),
                const SizedBox(height: 8),
                _buildImageDropzone(),
                const SizedBox(height: 16),
                
                // Capacity Stepper
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Capacity',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                          Text(
                            'Max participants',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.remove, size: 16)),
                            const Text('150', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.add, size: 16)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                _buildLabel('EVENT TYPE'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    _buildChip('Workshop', isActive: true),
                    _buildChip('Seminar'),
                    _buildChip('Social'),
                    _buildChip('Sport'),
                    _buildChip('Other'),
                  ],
                ),
                
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event_busy, color: Colors.redAccent, size: 16),
                        const SizedBox(width: 6),
                        const Text(
                          'DEADLINE: OCT\n24, 2024',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6E53),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Publish\nEvent', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Upcoming\nEvents',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1A1A1A),
            height: 1.1,
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
              child: const Text('12 Total', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 12),
            const Text(
              'View\nArchive',
              textAlign: TextAlign.right,
              style: TextStyle(color: Color(0xFF0D6E53), fontWeight: FontWeight.w800, fontSize: 11),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward, color: Color(0xFF0D6E53), size: 14),
          ],
        )
      ],
    );
  }

  Widget _buildUpcomingEventCard({
    required String dateStr,
    Color? dateBg,
    required String type,
    required Color typeColor,
    required Color typeTextColor,
    required String title,
    required String subtitle,
    required double progress,
    required String progressText,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: dateBg ?? const Color(0xFFEAF5F0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    dateStr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dateBg != null ? Colors.grey.shade600 : const Color(0xFF0D6E53),
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: typeColor, borderRadius: BorderRadius.circular(4)),
                      child: Text(type, style: TextStyle(color: typeTextColor, fontSize: 8, fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(height: 6),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('REGISTRATION', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.grey)),
              Text(progressText, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D6E53)),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
               Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(color: statusTextColor, fontSize: 10, fontWeight: FontWeight.w900)),
              ),
              const Spacer(),
              Icon(Icons.edit_outlined, color: Colors.grey.shade500, size: 18),
              const SizedBox(width: 16),
              Icon(Icons.delete_outline, color: Colors.grey.shade500, size: 18),
              const SizedBox(width: 16),
              Icon(Icons.share_outlined, color: Colors.grey.shade500, size: 18),
            ],
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

  Widget _buildTextField(String hint, {IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade600, size: 20) : null,
        ),
      ),
    );
  }

  Widget _buildImageDropzone() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        // Use placeholder background logic in real app
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade500, size: 28),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: 'Drop image or ',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              children: const [
                TextSpan(text: 'browse', style: TextStyle(color: Color(0xFF0D6E53), fontWeight: FontWeight.w800)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0D6E53) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w700,
          fontSize: 13,
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
            _buildNavItem(Icons.campaign_outlined, false),
            // Middle action button container matching the screenshot layout
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0D6E53),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.calendar_today, color: Colors.white, size: 22),
            ),
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
