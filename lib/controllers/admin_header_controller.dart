import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/admin_header_model.dart';

class AdminHeaderController {
  // Static methods for handling authentication and user state

  /// Get current user authentication state
  static AdminHeaderModel getCurrentUserState(String selectedBarangay) {
    final user = FirebaseAuth.instance.currentUser;
    return AdminHeaderModel(
      selectedBarangay: selectedBarangay,
      isLoggedIn: user != null,
      currentUserId: user?.uid,
      currentUserEmail: user?.email,
    );
  }

  /// Handle user logout
  static Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      // Log error appropriately in production
      debugPrint('Error logging out: $e');
      return false;
    }
  }

  /// Check if user is currently authenticated
  static bool isUserAuthenticated() {
    return FirebaseAuth.instance.currentUser != null;
  }

  /// Get current user
  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  /// Get current user ID
  static String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  /// Get current user email
  static String? getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  /// Update search query in model
  static AdminHeaderModel updateSearchQuery(AdminHeaderModel currentModel, String query) {
    return currentModel.copyWith(searchQuery: query.toLowerCase().trim());
  }

  /// Clear search query
  static AdminHeaderModel clearSearchQuery(AdminHeaderModel currentModel) {
    return currentModel.copyWith(searchQuery: '');
  }

  /// Validate search query
  static bool isValidSearchQuery(String query) {
    return query.trim().isNotEmpty;
  }

  /// Format barangay display text
  static String formatBarangayText(String barangay) {
    return 'Brgy $barangay, Cebu City';
  }

  /// Handle search input changes
  static String processSearchInput(String input) {
    return input.trim();
  }

  /// Get authentication stream
  static Stream<User?> getAuthStateStream() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
