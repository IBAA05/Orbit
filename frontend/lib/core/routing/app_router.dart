import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/biometrics_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/announcements/presentation/screens/announcements_screen.dart';
import '../../features/announcements/presentation/screens/announcement_details_screen.dart';
import '../../features/events/presentation/screens/events_screen.dart';
import '../../features/events/presentation/screens/event_details_screen.dart';
import '../../features/feed/presentation/screens/campus_feed_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/maps/presentation/screens/campus_map_screen.dart';
import '../../features/timetable/presentation/screens/schedule_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      
      case AppRoutes.biometrics:
        return MaterialPageRoute(
          builder: (_) => const BiometricsScreen(),
          settings: settings,
        );
        
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
        
      case AppRoutes.schedule:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());

      case AppRoutes.announcements:
        return MaterialPageRoute(builder: (_) => const AnnouncementsScreen());

      case AppRoutes.announcementDetails:
        return MaterialPageRoute(
          builder: (_) => const AnnouncementDetailsScreen(),
          settings: settings,
        );

      case AppRoutes.events:
        return MaterialPageRoute(builder: (_) => const EventsScreen());

      case AppRoutes.eventDetails:
        return MaterialPageRoute(
          builder: (_) => const EventDetailsScreen(),
          settings: settings,
        );

      case AppRoutes.feed:
        return MaterialPageRoute(builder: (_) => const CampusFeedScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case AppRoutes.map:
        return MaterialPageRoute(builder: (_) => const CampusMapScreen());
        
      default:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(label: '404'),
        );
    }
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(label)),
    );
  }
}