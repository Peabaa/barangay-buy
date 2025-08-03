import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_products_model.dart';
import '../views/user/home.dart';
import '../views/user/user_announcements.dart';
import '../views/user/user_sell.dart';
import '../views/user/user_profile.dart';

class CategoryProductsController {
  final CategoryProductsModel _model = CategoryProductsModel();

  Stream<QuerySnapshot> getProductsByCategory(String category, String barangay) {
    return _model.getProductsByCategory(category, barangay);
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

  void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onNotificationTap() {
    // Handle notification tap 
  }
}