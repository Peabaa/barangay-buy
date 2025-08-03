import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data();
    }
    return null;
  }

  // Update user's barangay
  Future<void> updateUserBarangay(String barangay) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'barangay': barangay,
      });
    }
  }

  // Get user's products stream
  Stream<QuerySnapshot> getUserProductsStream(String? barangay) {
    final user = _auth.currentUser;
    if (user != null) {
      if (barangay != null && barangay.isNotEmpty) {
        return _firestore
            .collection('products')
            .where('sellerId', isEqualTo: user.uid)
            .where('barangay', isEqualTo: barangay)
            .snapshots();
      } else {
        return _firestore
            .collection('products')
            .where('sellerId', isEqualTo: user.uid)
            .snapshots();
      }
    }
    return const Stream.empty();
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  // Get user's favorites
  Future<DocumentSnapshot> getUserFavorites() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
    }
    throw Exception('No user logged in');
  }

  // Get favorite products stream
  Stream<QuerySnapshot> getFavoriteProductsStream(List<dynamic> favorites, String barangay) {
    if (favorites.isEmpty) return const Stream.empty();
    
    return _firestore
        .collection('products')
        .where('productId', whereIn: favorites.length > 10 ? favorites.sublist(0, 10) : favorites)
        .where('barangay', isEqualTo: barangay)
        .snapshots();
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get barangay list
  List<String> getBarangayList() {
    return [
      'Banilad',
      'Bulacao',
      'Day-as',
      'Ermita',
      'Guadalupe',
      'Inayawan',
      'Labangon',
      'Lahug',
      'Pari-an',
      'Pasil'
    ];
  }
}
