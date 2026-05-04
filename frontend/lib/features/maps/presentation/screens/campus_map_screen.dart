import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../../../../core/routing/app_routes.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(36.7538, 3.0588); // Default center
  LatLng? _currentPosition;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  /// Handles GPS permissions and initial location fetch
  Future<void> _determinePosition() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    setState(() => _isLocating = true);

    // 1. Check if location service is enabled, and request if not
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable GPS to see your position.')),
          );
        }
        setState(() => _isLocating = false);
        return;
      }
    }

    // 2. Check for permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() => _isLocating = false);
        return;
      }
    }

    if (permissionGranted == PermissionStatus.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are permanently denied. Please enable them in settings.')),
        );
      }
      setState(() => _isLocating = false);
      return;
    }

    // 3. Get current location
    try {
      final locationData = await location.getLocation();

      if (mounted) {
        setState(() {
          _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
          _center = _currentPosition!;
          _isLocating = false;
        });
        _mapController.move(_center, 15.0);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLocating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('GPS Error: ${e.toString()}')),
        );
      }
    }
  }

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
            'Orbit Map',
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
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
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
              MarkerLayer(
                markers: [
                  // User Location Marker
                  if (_currentPosition != null)
                    Marker(
                      point: _currentPosition!,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.white, blurRadius: 4)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Campus Markers
                  _buildMapMarker(const LatLng(36.7538, 3.0588), Icons.school, 'Main Hall'),
                  _buildMapMarker(const LatLng(36.7545, 3.0595), Icons.library_books, 'Library'),
                ],
              ),
            ],
          ),
          
          // Search Bar Overlay
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 8))],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search campus...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Location FAB
          Positioned(
            right: 20,
            bottom: 280,
            child: FloatingActionButton(
              onPressed: _determinePosition,
              backgroundColor: const Color(0xFF0D6E53),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: _isLocating 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          // Bottom Sheet Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text('Nearby Campus Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  _buildListTile(Icons.wifi, 'Student Lounge', 'Free Campus WiFi • 2min'),
                  _buildListTile(Icons.medical_services_outlined, 'Health Center', 'Medical Staff on Duty • 5min'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Marker _buildMapMarker(LatLng point, IconData icon, String label) {
    return Marker(
      point: point,
      width: 80,
      height: 80,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: Color(0xFF0D6E53), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String sub) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
        child: Icon(icon, color: const Color(0xFF0D6E53), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(context, Icons.home_outlined, AppRoutes.home, false),
              _buildNavItem(context, Icons.calendar_month_outlined, AppRoutes.announcements, false),
              _buildNavItem(context, Icons.bolt_outlined, AppRoutes.feed, false),
              _buildNavItem(context, Icons.map, AppRoutes.map, true),
              _buildNavItem(context, Icons.person_outline, AppRoutes.profile, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String route, bool isSelected) {
    return GestureDetector(
      onTap: () => isSelected ? null : Navigator.pushReplacementNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: isSelected ? const Color(0xFF0D6E53) : Colors.transparent, shape: BoxShape.circle),
        child: Icon(icon, color: isSelected ? Colors.white : const Color(0xFF757575), size: 26),
      ),
    );
  }
}
