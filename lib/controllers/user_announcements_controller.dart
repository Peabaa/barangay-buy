import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_announcements_model.dart';
import '../views/user/home.dart';
import '../views/user/user_sell.dart';
import '../views/user/user_profile.dart';
import '../views/user/search_results.dart';

class UserAnnouncementsController {
  final UserAnnouncementsModel _model = UserAnnouncementsModel();

  // Get current user's barangay
  Future<String> getCurrentUserBarangay() async {
    return await _model.getCurrentUserBarangay();
  }

  // Fetch all announcements
  Future<List<Map<String, dynamic>>> fetchAllAnnouncements(String barangay) async {
    return await _model.fetchAllAnnouncements(barangay);
  }

  // Filter announcements based on search query
  List<Map<String, dynamic>> filterAnnouncements(
    List<Map<String, dynamic>> announcements, 
    String searchQuery
  ) {
    if (searchQuery.isEmpty) return announcements;
    
    return announcements.where((announcement) {
      final text = (announcement['text'] ?? '').toString().toLowerCase();
      final username = (announcement['username'] ?? '').toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      return text.contains(query) || username.contains(query);
    }).toList();
  }

  // Set system UI overlay style
  void setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFF5B29),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // Navigation methods
  void navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void navigateToAnnouncements(BuildContext context) {
    // Already on announcements page, no navigation needed
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

  void navigateToSearchResults(
    BuildContext context, 
    String query, 
    String barangay,
    double Function(double) relWidth,
    double Function(double) relHeight
  ) {
    if (query.trim().isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchResults(
            searchQuery: query,
            barangay: barangay,
            relWidth: relWidth,
            relHeight: relHeight,
          ),
        ),
      );
    }
  }

  // Handle notification tap
  void handleNotificationTap() {
    // Placeholder for notification functionality
  }
}