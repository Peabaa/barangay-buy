import 'package:flutter/material.dart';
import '../models/home_header_footer_model.dart';
import '../views/user/user_notifications.dart';
import '../views/user/home.dart';
import '../views/user/user_announcements.dart';
import '../views/user/user_sell.dart';
import '../views/user/user_profile.dart';

class HomeHeaderFooterController {
  final HomeHeaderFooterModel _model = HomeHeaderFooterModel();

  // Get current user's barangay
  Future<String> getCurrentUserBarangay() async {
    return await _model.getCurrentUserBarangay();
  }

  // Get notification count
  Future<int> getNotificationCount() async {
    return await _model.getNotificationCount();
  }

  // Navigate to notifications
  void navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserNotificationsScreen(),
      ),
    );
  }

  // Footer navigation methods
  void navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void navigateToAnnouncements(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const UserAnnouncements(),
      ),
    );
  }

  void navigateToSell(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const UserSell(),
      ),
    );
  }

  void navigateToProfile(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const UserProfile(),
      ),
    );
  }

  // Handle search functionality
  void handleSearchChanged(String query, ValueChanged<String>? onSearchChanged) {
    if (onSearchChanged != null) {
      onSearchChanged(query);
    }
  }

  void handleSearchSubmitted(String query, ValueChanged<String>? onSearchSubmitted) {
    if (onSearchSubmitted != null) {
      onSearchSubmitted(query);
    }
  }
}