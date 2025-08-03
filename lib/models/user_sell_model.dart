import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:convert';

class UserSellModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's barangay
  Future<String> getCurrentUserBarangay() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data()?['barangay'] ?? '';
    }
    return '';
  }

  // Convert image to Base64
  Future<String?> convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error converting image to Base64: $e');
      return null;
    }
  }

  // Submit product to Firebase
  Future<void> submitProduct({
    required String productName,
    required double price,
    required String category,
    required String description,
    required String barangay,
    String? imageBase64,
    bool hasImage = false,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Get user information
    final userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    
    final username = userDoc.data()?['username'] ?? user.email ?? 'Unknown';

    // Create product data with Base64 image
    final productData = {
      'productName': productName,
      'price': price,
      'category': category,
      'description': description,
      'barangay': barangay,
      'sellerName': username,
      'sellerEmail': user.email,
      'sellerId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'active', // active, sold, inactive
      'hasImage': hasImage,
      'imageBase64': imageBase64, // Store Base64 encoded image
    };

    // Add to user's products collection
    final userProductRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('products')
        .add(productData);

    final globalProductRef = await _firestore
        .collection('products')
        .add(productData);

    await userProductRef.update({'productId': globalProductRef.id});
    await globalProductRef.update({'productId': globalProductRef.id});
  }

  // Get available categories
  List<String> getCategories() {
    return [
      'Fashion',
      'Electronics',
      'Home Living',
      'Health & Beauty',
      'Groceries',
      'Entertainment',
    ];
  }

  // Validate product data
  Map<String, String?> validateProductData({
    required String productName,
    required String price,
    required String? category,
    required String description,
  }) {
    Map<String, String?> errors = {};

    if (productName.trim().isEmpty) {
      errors['productName'] = 'Please enter a product name';
    }

    if (price.trim().isEmpty) {
      errors['price'] = 'Please enter a product price';
    } else {
      final priceValue = double.tryParse(price.trim());
      if (priceValue == null || priceValue <= 0) {
        errors['price'] = 'Please enter a valid price';
      }
    }

    if (category == null) {
      errors['category'] = 'Please select a category';
    }

    if (description.trim().isEmpty) {
      errors['description'] = 'Please enter a product description';
    }

    return errors;
  }
}
