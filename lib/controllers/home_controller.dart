import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/home_model.dart';
import '../views/user/user_announcements.dart';
import '../views/user/user_sell.dart';
import '../views/user/user_profile.dart';
import '../views/user/category_products.dart';
import '../views/user/search_results.dart';

class HomeController {
  final HomeModel _model = HomeModel();

  // Get current user's barangay
  Future<String> getCurrentUserBarangay() async {
    return await _model.getCurrentUserBarangay();
  }

  // Get products stream
  Stream<QuerySnapshot> getProductsByBarangay(String barangay) {
    return _model.getProductsByBarangay(barangay);
  }

  // Get categories
  List<String> getCategories() {
    return _model.getCategories();
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
    // Already on home, no navigation needed
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

  void navigateToCategory(BuildContext context, String category, String barangay, 
      double Function(double) relWidth, double Function(double) relHeight) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryProducts(
          category: category,
          barangay: barangay,
          relWidth: relWidth,
          relHeight: relHeight,
        ),
      ),
    );
  }

  void navigateToSearchResults(BuildContext context, String query, String barangay,
      double Function(double) relWidth, double Function(double) relHeight) {
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
    print('Notification tapped');
  }

  // Handle search functionality
  void handleSearchChanged(String query, Function(String) onSearchChanged) {
    onSearchChanged(query);
  }

  void handleSearchSubmitted(BuildContext context, String query, String barangay,
      double Function(double) relWidth, double Function(double) relHeight) {
    navigateToSearchResults(context, query, barangay, relWidth, relHeight);
  }
}