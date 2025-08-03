import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/user_sell_model.dart';
import '../views/user/home.dart';
import '../views/user/user_announcements.dart';
import '../views/user/user_profile.dart';
import '../views/user/user_notifications.dart';
import '../views/user/search_results.dart';

class UserSellController {
  final UserSellModel _model = UserSellModel();

  // Get current user's barangay
  Future<String> getCurrentUserBarangay() async {
    return await _model.getCurrentUserBarangay();
  }

  // Pick image from gallery
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Validate form completion
  bool isFormComplete({
    required String productName,
    required String price,
    required String? category,
    required String description,
  }) {
    return productName.trim().isNotEmpty &&
        price.trim().isNotEmpty &&
        double.tryParse(price.trim()) != null &&
        double.parse(price.trim()) > 0 &&
        category != null &&
        description.trim().isNotEmpty;
  }

  // Submit product
  Future<void> submitProduct({
    required String productName,
    required String price,
    required String? category,
    required String description,
    required String barangay,
    File? productImage,
  }) async {
    // Validate form data
    final errors = _model.validateProductData(
      productName: productName,
      price: price,
      category: category,
      description: description,
    );

    if (errors.isNotEmpty) {
      throw Exception(errors.values.first);
    }

    final priceValue = double.parse(price.trim());

    // Convert image to Base64 if image exists
    String? imageBase64;
    if (productImage != null) {
      imageBase64 = await _model.convertImageToBase64(productImage);
      if (imageBase64 == null) {
        throw Exception('Error processing image. Please try again.');
      }
    }

    // Submit to model
    await _model.submitProduct(
      productName: productName.trim(),
      price: priceValue,
      category: category!,
      description: description.trim(),
      barangay: barangay,
      imageBase64: imageBase64,
      hasImage: productImage != null,
    );
  }

  // Get available categories
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
    // Already on sell page, no navigation needed
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

  // Navigate to notifications
  void navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserNotificationsScreen(),
      ),
    );
  }

  // Show snack bar message
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF611A04),
      ),
    );
  }
}
