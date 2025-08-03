import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductCardModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Check if product is in user's favorites
  Future<bool> isFavoriteProduct(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final favorites = userDoc.data()?['favorites'] as List<dynamic>?;
      return favorites != null && favorites.contains(productId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // Add product to favorites
  Future<void> addToFavorites(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      
      final userRef = _firestore.collection('users').doc(user.uid);
      await userRef.set({
        'favorites': FieldValue.arrayUnion([productId])
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  // Remove product from favorites
  Future<void> removeFromFavorites(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      
      final userRef = _firestore.collection('users').doc(user.uid);
      await userRef.update({
        'favorites': FieldValue.arrayRemove([productId])
      });
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  // Get current user's username
  Future<String> getCurrentUsername() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'Someone';
      
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc.data()?['username'] ?? 'Someone';
    } catch (e) {
      print('Error getting username: $e');
      return 'Someone';
    }
  }

  // Get product details
  Future<Map<String, dynamic>?> getProductDetails(String productId) async {
    try {
      final productDoc = await _firestore.collection('products').doc(productId).get();
      return productDoc.exists ? productDoc.data() : null;
    } catch (e) {
      print('Error getting product details: $e');
      return null;
    }
  }

  // Create favorite notification
  Future<void> createFavoriteNotification({
    required String sellerId,
    required String username,
    required String productName,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': sellerId,
        'type': 'favorite',
        'username': username,
        'productName': productName,
        'comment': '',
        'reply': '',
        'title': '',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      print('Error creating favorite notification: $e');
    }
  }
}