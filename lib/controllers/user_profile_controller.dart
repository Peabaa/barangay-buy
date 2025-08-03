import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';
import '../views/user/home.dart';
import '../views/user/user_announcements.dart';
import '../views/user/user_sell.dart';
import '../views/user/search_results.dart';
import '../views/login_signup.dart';

class UserProfileController {
  final UserProfileModel _model = UserProfileModel();

  // Get current user's data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    return await _model.getCurrentUserData();
  }

  // Update user's barangay
  Future<void> updateUserBarangay(String barangay) async {
    await _model.updateUserBarangay(barangay);
  }

  // Get user's products stream
  Stream<QuerySnapshot> getUserProductsStream(String? barangay) {
    return _model.getUserProductsStream(barangay);
  }

  // Delete product with confirmation
  Future<bool?> showDeleteConfirmation(
    BuildContext context,
    double Function(double) relWidth,
    double Function(double) relHeight,
  ) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: relWidth(312),
            height: relHeight(230),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F2F2),
              borderRadius: BorderRadius.circular(relWidth(3)),
              border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 0.22),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: relWidth(215),
                  height: relHeight(25),
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: relHeight(7)),
                  child: Text(
                    'Delete Listing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(18),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      height: 1.17182,
                      letterSpacing: 0.32,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Divider(
                  color: const Color.fromRGBO(0, 0, 0, 0.22),
                  thickness: 1,
                  height: relHeight(16),
                ),
                Container(
                  width: relWidth(232),
                  height: relHeight(81),
                  alignment: Alignment.center,
                  child: Text(
                    'Do you want to delete this product listing?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(20),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      height: 1.17182,
                      letterSpacing: 0.4,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(height: relHeight(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Container(
                        width: relWidth(90),
                        height: relHeight(28),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(relWidth(3)),
                          border: Border.all(
                            color: const Color(0xFF611A04),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: const Color(0xFF611A04),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: relWidth(16),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: relWidth(16)),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        width: relWidth(90),
                        height: relHeight(28),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(relWidth(3)),
                          border: Border.all(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: relWidth(16),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    await _model.deleteProduct(productId);
  }

  // Get user's favorites
  Future<DocumentSnapshot> getUserFavorites() async {
    return await _model.getUserFavorites();
  }

  // Get favorite products stream
  Stream<QuerySnapshot> getFavoriteProductsStream(List<dynamic> favorites, String barangay) {
    return _model.getFavoriteProductsStream(favorites, barangay);
  }

  // Show logout confirmation
  void showLogoutConfirmation(
    BuildContext context,
    double Function(double) relWidth,
    double Function(double) relHeight,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: relWidth(312),
            height: relHeight(230),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F2F2),
              borderRadius: BorderRadius.circular(relWidth(3)),
              border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 0.22),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: relWidth(215),
                  height: relHeight(25),
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: relHeight(7)),
                  child: Text(
                    'Log Out',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(18),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      height: 1.17182,
                      letterSpacing: 0.32,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Divider(
                  color: const Color.fromRGBO(0, 0, 0, 0.22),
                  thickness: 1,
                  height: relHeight(16),
                ),
                Container(
                  width: relWidth(232),
                  height: relHeight(81),
                  alignment: Alignment.center,
                  child: Text(
                    'Do you want to log out?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(20),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      height: 1.17182,
                      letterSpacing: 0.4,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(height: relHeight(15)),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await handleLogout(context);
                  },
                  child: Container(
                    width: relWidth(133),
                    height: relHeight(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF611A04).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(relWidth(3)),
                      border: Border.all(
                        color: const Color(0xFF611A04),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: relWidth(16),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Handle logout
  Future<void> handleLogout(BuildContext context) async {
    try {
      await _model.signOut();
    } catch (e) {
      // Handle error silently as in original code
    }
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginSignupScreen(),
        ),
        (route) => false,
      );
    }
  }

  // Filter products based on search query
  List<QueryDocumentSnapshot> filterProducts(
    List<QueryDocumentSnapshot> products,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) return products;
    
    return products.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final productName = (data['productName'] ?? '').toString().toLowerCase();
      final category = (data['category'] ?? '').toString().toLowerCase();
      return productName.contains(searchQuery.toLowerCase()) || 
             category.contains(searchQuery.toLowerCase());
    }).toList();
  }

  // Get barangay list
  List<String> getBarangayList() {
    return _model.getBarangayList();
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
    // Already on profile page, no navigation needed
  }

  void navigateToSearchResults(
    BuildContext context,
    String query,
    String barangay,
    double Function(double) relWidth,
    double Function(double) relHeight,
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
