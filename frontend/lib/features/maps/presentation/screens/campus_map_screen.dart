import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/routing/app_routes.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final MapController _mapController = MapController();

  final LatLng _center = const LatLng(36.7538, 3.0588); // Example coordinates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            'Orbit',
            style: TextStyle(
              color: Color(0xFF0D6E53),
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Color(0xFF0D6E53)),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // MAP Placeholder/Mock
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.orbit',
              ),
            ],
          ),
          
          // Custom Overlay Elements from Image
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search buildings, labs, or dining...',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  Icon(Icons.mic_none, color: Colors.grey),
                ],
              ),
            ),
          ),

          // Map Pins Mock (using Stack and Positioned for UI fidelity)
          _buildMapPin(top: 240, left: 180, icon: Icons.school, label: 'Main Hall'),
          _buildMapPin(top: 180, right: 60, icon: Icons.library_books, label: 'Central Library'),
          _buildMapPin(bottom: 240, left: 100, icon: Icons.restaurant, label: 'Food Court', color: Colors.red.shade400),

          // Location Fab
          Positioned(
            right: 20,
            bottom: 280,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF0D6E53),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          // Bottom Sheet Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 260),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nearby Places',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'VIEW ALL',
                              style: TextStyle(
                                color: Color(0xFF1E659A),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildCategoryPill('All', isSelected: true),
                          const SizedBox(width: 12),
                          _buildCategoryPill('Academic', isSelected: false),
                          const SizedBox(width: 12),
                          _buildCategoryPill('Food', isSelected: false),
                          const SizedBox(width: 12),
                          _buildCategoryPill('Library', isSelected: false),
                          const SizedBox(width: 12),
                          _buildCategoryPill('Housing', isSelected: false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildPlaceCard(
                            title: 'Science Library',
                            distance: '200m',
                            status: 'Open until 8PM',
                            imageUrl: 'https://via.placeholder.com/300x200/0D6E53/FFFFFF?text=Library',
                          ),
                          const SizedBox(width: 16),
                          _buildPlaceCard(
                            title: 'Food Court',
                            distance: '450m',
                            status: 'Busy',
                            imageUrl: 'https://via.placeholder.com/300x200/F44336/FFFFFF?text=Food',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Space for bottom navbar
                  ],
                ),
              ),
            ),
          ),
        ],
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
                color: Colors.black.withValues(alpha: 0.1),
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
                _buildNavItem(context, icon: Icons.calendar_month_outlined, isSelected: false, route: AppRoutes.announcements),
                _buildNavItem(context, icon: Icons.bolt_outlined, isSelected: false, route: AppRoutes.feed),
                _buildNavItem(context, icon: Icons.map, isSelected: true, route: AppRoutes.map),
                _buildNavItem(context, icon: Icons.person_outline, isSelected: false, route: AppRoutes.profile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapPin({double? top, double? left, double? right, double? bottom, required IconData icon, required String label, Color color = const Color(0xFF0D6E53)}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E659A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String text, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0D6E53) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildPlaceCard({required String title, required String distance, required String status, required String imageUrl}) {
    return Container(
      width: 200, // This is your fixed width
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Keep the row tight
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              // Add an error builder to prevent crashes if the URL fails
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey, width: 50, height: 50),
            ),
          ),
          const SizedBox(width: 12),
          // Expanded is crucial here to prevent the text from pushing the Row wider than 200px
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$distance • $status',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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
