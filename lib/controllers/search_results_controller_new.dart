import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/search_results_model.dart';
import '../views/user/home.dart';
import '../views/user/user_announcements.dart';
import '../views/user/user_sell.dart';
import '../views/user/user_profile.dart';

class SearchResultsController {
  final SearchResultsModel _model = SearchResultsModel();

  // Get products stream by barangay
  Stream<QuerySnapshot> getProductsByBarangay(String barangay) {
    return _model.getProductsByBarangay(barangay);
  }

  // Filter products by search query using model
  List<QueryDocumentSnapshot> filterProducts(
    List<QueryDocumentSnapshot> products, 
    String searchQuery
  ) {
    return _model.filterProductsByQuery(products, searchQuery);
  }

  // Check if search results exist
  bool hasSearchResults(List<QueryDocumentSnapshot> filteredProducts) {
    return filteredProducts.isNotEmpty;
  }

  // Get appropriate no results message
  String getNoResultsMessage(String searchQuery) {
    if (searchQuery.trim().isEmpty) {
      return '--- No Items Found. ---';
    }
    return '--- No results for "$searchQuery" ---';
  }

  // Navigation methods
  void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

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

  // Handle notification tap
  void handleNotificationTap() {
    // Notification functionality can be implemented here
  }

  // Handle search functionality
  void handleSearchChanged(String query) {
    // Could be used for real-time search filtering
  }

  // Get page title with search query
  String getPageTitle(String searchQuery) {
    if (searchQuery.trim().isEmpty) {
      return 'Search Results';
    }
    return 'Results for "$searchQuery"';
  }

  // Get results count message
  String getResultsCountMessage(int count, String searchQuery) {
    if (count == 0) {
      return 'No results found';
    } else if (count == 1) {
      return '1 result found';
    } else {
      return '$count results found';
    }
  }
} 