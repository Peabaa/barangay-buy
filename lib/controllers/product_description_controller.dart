import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../models/product_description_model.dart';
import '../views/user/home.dart';
import '../views/user/user_announcements.dart';
import '../views/user/user_sell.dart';
import '../views/user/user_profile.dart';

class ProductDescriptionController {
  final ProductDescriptionModel _model = ProductDescriptionModel();

  // Initialize data
  Future<Map<String, dynamic>> initializeData(String productId) async {
    final barangay = await _model.getCurrentUserBarangay();
    final isFavorite = await _model.isFavoriteProduct(productId);
    final productDetails = await _model.getProductDetails(productId);
    
    return {
      'barangay': barangay,
      'isFavorite': isFavorite,
      'productDetails': productDetails,
    };
  }

  // Check if current user is the product owner
  bool isOwner(Map<String, dynamic>? productDetails) {
    final currentUserId = _model.getCurrentUserId();
    return currentUserId != null && productDetails?['sellerId'] == currentUserId;
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(String productId, bool currentStatus) async {
    await _model.toggleFavorite(productId, currentStatus);
    
    if (!currentStatus) {
      // Creating favorite notification
      final username = await _model.getCurrentUsername();
      await _model.createFavoriteNotification(
        productId: productId,
        currentUsername: username,
      );
    }
    
    return !currentStatus;
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

  // Format timestamp
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final DateTime dateTime = timestamp.toDate();
    final Duration difference = DateTime.now().difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  // Update product field
  Future<void> updateProductField(String productId, String field, String value) async {
    await _model.updateProductField(productId, field, value);
  }

  // Add comment
  Future<void> addComment(String productId, String commentText) async {
    final username = await _model.getCurrentUsername();
    final currentUserId = _model.getCurrentUserId();
    
    if (currentUserId != null) {
      await _model.addComment(
        productId: productId,
        username: username,
        comment: commentText,
        commenterId: currentUserId,
      );
      
      await _model.createCommentNotification(
        productId: productId,
        commenterUsername: username,
        commentText: commentText,
      );
    }
  }

  // Add reply
  Future<void> addReply(String productId, String commentId, String replyText, String originalCommenterId) async {
    final username = await _model.getCurrentUsername();
    final currentUserId = _model.getCurrentUserId();
    
    if (currentUserId != null) {
      await _model.addReply(
        productId: productId,
        commentId: commentId,
        username: username,
        reply: replyText,
        commenterId: currentUserId,
      );
      
      await _model.createReplyNotification(
        productId: productId,
        replierUsername: username,
        replyText: replyText,
        originalCommenterId: originalCommenterId,
      );
    }
  }

  // Delete comment
  Future<void> deleteComment(String productId, String commentId) async {
    print('Controller: Attempting to delete comment $commentId from product $productId');
    try {
      await _model.deleteComment(productId, commentId);
      print('Controller: Comment deleted successfully');
    } catch (e) {
      print('Controller: Error deleting comment: $e');
      rethrow;
    }
  }

  // Delete reply
  Future<void> deleteReply(String productId, String commentId, String replyId) async {
    print('Controller: Attempting to delete reply $replyId from comment $commentId in product $productId');
    try {
      await _model.deleteReply(productId, commentId, replyId);
      print('Controller: Reply deleted successfully');
    } catch (e) {
      print('Controller: Error deleting reply: $e');
      rethrow;
    }
  }

  // Check if user owns comment/reply
  bool isOwnComment(String commenterId) {
    final currentUserId = _model.getCurrentUserId();
    print('Controller: Checking ownership - Current user: $currentUserId, Commenter: $commenterId');
    final isOwner = currentUserId != null && commenterId == currentUserId;
    print('Controller: Is owner: $isOwner');
    return isOwner;
  }

  // Get comments stream
  Stream<QuerySnapshot> getCommentsStream(String productId) {
    return _model.getCommentsStream(productId);
  }

  // Get replies stream
  Stream<QuerySnapshot> getRepliesStream(String productId, String commentId) {
    return _model.getRepliesStream(productId, commentId);
  }

  // Navigation methods
  void navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void navigateToAnnouncements(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const UserAnnouncements()),
    );
  }

  void navigateToSell(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const UserSell()),
    );
  }

  void navigateToProfile(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const UserProfile()),
    );
  }

  void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}