import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDescriptionModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Test Firestore permissions
  Future<void> testFirestorePermissions() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('Test: User not authenticated');
        return;
      }
      
      print('Test: Testing Firestore permissions for user: ${user.uid}');
      
      // Test creating a test document
      final testRef = _firestore.collection('test').doc('test_doc');
      await testRef.set({'test': 'data', 'userId': user.uid});
      print('Test: Successfully created test document');
      
      // Test reading the document
      final testDoc = await testRef.get();
      print('Test: Successfully read test document: ${testDoc.exists}');
      
      // Test deleting the document
      await testRef.delete();
      print('Test: Successfully deleted test document');
      
    } catch (e) {
      print('Test: Firestore permission error: $e');
    }
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Get current user's barangay
  Future<String> getCurrentUserBarangay() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        return userDoc.data()?['barangay'] ?? '';
      }
      return '';
    } catch (e) {
      print('Error fetching user barangay: $e');
      return '';
    }
  }

  // Check if product is in favorites
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

  // Get product details
  Future<Map<String, dynamic>?> getProductDetails(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error loading product details: $e');
      return null;
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String productId, bool isFavorite) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      
      final userRef = _firestore.collection('users').doc(user.uid);
      if (isFavorite) {
        await userRef.update({
          'favorites': FieldValue.arrayRemove([productId])
        });
      } else {
        await userRef.set({
          'favorites': FieldValue.arrayUnion([productId])
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  // Get current username
  Future<String> getCurrentUsername() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'Someone';
      
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc.data()?['username'] ?? user.email ?? 'Someone';
    } catch (e) {
      print('Error getting username: $e');
      return 'Someone';
    }
  }

  // Create favorite notification
  Future<void> createFavoriteNotification({
    required String productId,
    required String currentUsername,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final productDoc = await _firestore.collection('products').doc(productId).get();
      
      if (productDoc.exists) {
        final productData = productDoc.data()!;
        final sellerId = productData['sellerId'];
        final productName = productData['productName'] ?? 'your product';
        
        // Don't create notification if user is favoriting their own product
        if (sellerId != user.uid) {
          await _firestore.collection('notifications').add({
            'userId': sellerId,
            'type': 'favorite',
            'username': currentUsername,
            'productName': productName,
            'comment': '',
            'reply': '',
            'title': '',
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });
        }
      }
    } catch (e) {
      print('Error creating favorite notification: $e');
    }
  }

  // Create comment notification
  Future<void> createCommentNotification({
    required String productId,
    required String commenterUsername,
    required String commentText,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final productDoc = await _firestore.collection('products').doc(productId).get();
      
      if (productDoc.exists) {
        final productData = productDoc.data()!;
        final sellerId = productData['sellerId'];
        final productName = productData['productName'] ?? 'your product';
        
        // Don't create notification if user is commenting on their own product
        if (sellerId != user.uid) {
          await _firestore.collection('notifications').add({
            'userId': sellerId,
            'type': 'comment',
            'username': commenterUsername,
            'productName': productName,
            'comment': commentText,
            'reply': '',
            'title': '',
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });
        }
      }
    } catch (e) {
      print('Error creating comment notification: $e');
    }
  }

  // Create reply notification
  Future<void> createReplyNotification({
    required String productId,
    required String replierUsername,
    required String replyText,
    required String originalCommenterId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final productDoc = await _firestore.collection('products').doc(productId).get();
      
      if (productDoc.exists) {
        final productData = productDoc.data()!;
        final productName = productData['productName'] ?? 'a product';
        
        // Don't create notification if user is replying to their own comment
        if (originalCommenterId != user.uid) {
          await _firestore.collection('notifications').add({
            'userId': originalCommenterId,
            'type': 'reply',
            'username': replierUsername,
            'productName': productName,
            'comment': '',
            'reply': replyText,
            'title': '',
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });
        }
      }
    } catch (e) {
      print('Error creating reply notification: $e');
    }
  }

  // Update product field
  Future<void> updateProductField(String productId, String field, String value) async {
    try {
      // Update main products collection
      await _firestore.collection('products').doc(productId).update({field: value});

      // Update user's products subcollection
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('products')
            .where('productId', isEqualTo: productId)
            .get();
        
        for (var doc in querySnapshot.docs) {
          await doc.reference.update({field: value});
        }
      }
    } catch (e) {
      print('Error updating product field: $e');
      throw e;
    }
  }

  // Add comment to product
  Future<void> addComment({
    required String productId,
    required String username,
    required String comment,
    required String commenterId,
  }) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .collection('comments')
          .add({
            'username': username,
            'comment': comment,
            'commenterId': commenterId,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error adding comment: $e');
      throw e;
    }
  }

  // Add reply to comment
  Future<void> addReply({
    required String productId,
    required String commentId,
    required String username,
    required String reply,
    required String commenterId,
  }) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .add({
            'username': username,
            'reply': reply,
            'commenterId': commenterId,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error adding reply: $e');
      throw e;
    }
  }

  // Delete comment
  Future<void> deleteComment(String productId, String commentId) async {
    print('Model: Attempting to delete comment $commentId from product $productId');
    
    // Check if user is authenticated
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Model: User is not authenticated');
      throw Exception('User not authenticated');
    }
    print('Model: Current user ID: ${currentUser.uid}');
    
    try {
      final docRef = _firestore
          .collection('products')
          .doc(productId)
          .collection('comments')
          .doc(commentId);
          
      print('Model: Document path: ${docRef.path}');
      
      // Check if document exists first and get its data
      final docSnapshot = await docRef.get();
      print('Model: Comment exists: ${docSnapshot.exists}');
      
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final commenterId = data?['commenterId'];
        print('Model: Comment owner ID: $commenterId');
        print('Model: Current user ID: ${currentUser.uid}');
        
        // Check if user owns the comment
        if (commenterId != currentUser.uid) {
          print('Model: User does not own this comment');
          throw Exception('User does not own this comment');
        }
        
        await docRef.delete();
        print('Model: Comment deleted successfully');
      } else {
        print('Model: Comment does not exist');
        throw Exception('Comment does not exist');
      }
    } catch (e) {
      print('Model: Error deleting comment: $e');
      throw e;
    }
  }

  // Delete reply
  Future<void> deleteReply(String productId, String commentId, String replyId) async {
    print('Model: Attempting to delete reply $replyId from comment $commentId in product $productId');
    
    // Check if user is authenticated
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Model: User is not authenticated');
      throw Exception('User not authenticated');
    }
    print('Model: Current user ID: ${currentUser.uid}');
    
    try {
      final docRef = _firestore
          .collection('products')
          .doc(productId)
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .doc(replyId);
          
      print('Model: Document path: ${docRef.path}');
      
      // Check if document exists first and get its data
      final docSnapshot = await docRef.get();
      print('Model: Reply exists: ${docSnapshot.exists}');
      
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final commenterId = data?['commenterId'];
        print('Model: Reply owner ID: $commenterId');
        print('Model: Current user ID: ${currentUser.uid}');
        
        // Check if user owns the reply
        if (commenterId != currentUser.uid) {
          print('Model: User does not own this reply');
          throw Exception('User does not own this reply');
        }
        
        await docRef.delete();
        print('Model: Reply deleted successfully');
      } else {
        print('Model: Reply does not exist');
        throw Exception('Reply does not exist');
      }
    } catch (e) {
      print('Model: Error deleting reply: $e');
      throw e;
    }
  }

  // Get comments stream
  Stream<QuerySnapshot> getCommentsStream(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get replies stream
  Stream<QuerySnapshot> getRepliesStream(String productId, String commentId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}