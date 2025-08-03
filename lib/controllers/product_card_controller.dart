import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../models/product_card_model.dart';
import '../views/user/product_description.dart';

class ProductCardController {
  final ProductCardModel _model = ProductCardModel();

  // Load favorite status for a product
  Future<bool> loadFavoriteStatus(String productId) async {
    return await _model.isFavoriteProduct(productId);
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(String productId, bool currentStatus) async {
    if (currentStatus) {
      await _model.removeFromFavorites(productId);
      return false;
    } else {
      await _model.addToFavorites(productId);
      await _createFavoriteNotification(productId);
      return true;
    }
  }

  // Create favorite notification
  Future<void> _createFavoriteNotification(String productId) async {
    try {
      final currentUserId = _model.getCurrentUserId();
      if (currentUserId == null) return;

      final username = await _model.getCurrentUsername();
      final productData = await _model.getProductDetails(productId);
      
      if (productData != null) {
        final sellerId = productData['sellerId'];
        final productName = productData['productName'] ?? 'your product';
        
        // Don't create notification if user is favoriting their own product
        if (sellerId != currentUserId) {
          await _model.createFavoriteNotification(
            sellerId: sellerId,
            username: username,
            productName: productName,
          );
        }
      }
    } catch (e) {
      print('Error creating favorite notification: $e');
    }
  }

  // Get category color
  Color getCategoryColor(String category) {
    switch (category) {
      case 'Fashion': 
        return const Color(0xFFC5007D);
      case 'Electronics': 
        return const Color(0xFF008AC5);
      case 'Home Living': 
        return const Color(0xFF00C5B5);
      case 'Health & Beauty': 
        return const Color(0xFF00C500);
      case 'Groceries': 
        return const Color(0xFFC57300);
      case 'Entertainment': 
        return const Color(0xFF9444C9);
      default: 
        return const Color(0xFF888888);
    }
  }

  // Convert base64 to image bytes
  Uint8List? convertBase64ToBytes(String base64String) {
    if (base64String.isEmpty) return null;
    
    try {
      return base64Decode(base64String);
    } catch (e) {
      print('Error decoding base64: $e');
      return null;
    }
  }

  // Navigate to product description
  void navigateToProductDescription(
    BuildContext context,
    String productId,
    String imageBase64,
    String name,
    String price,
    String category,
    String sold,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDescription(
          productId: productId,
          imageBase64: imageBase64,
          name: name,
          price: price,
          category: category,
          sold: sold,
        ),
      ),
    );
  }

  // Get product details for seller name
  Future<String> getSellerName(String productId) async {
    try {
      final productData = await _model.getProductDetails(productId);
      return productData?['sellerName'] ?? '-';
    } catch (e) {
      print('Error getting seller name: $e');
      return '-';
    }
  }
}