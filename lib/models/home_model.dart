import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's barangay
  Future<String> getCurrentUserBarangay() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        return userDoc.data()?['barangay'] ?? '';
      }
      return '';
    } catch (e) {
      print('Error fetching user barangay: $e');
      return '';
    }
  }

  // Get products stream by barangay
  Stream<QuerySnapshot> getProductsByBarangay(String barangay) {
    if (barangay.isNotEmpty) {
      return _firestore
          .collection('products')
          .where('barangay', isEqualTo: barangay)
          .snapshots();
    } else {
      return _firestore.collection('products').snapshots();
    }
  }

  // Get category list
  List<String> getCategories() {
    return [
      "Fashion",
      "Electronics", 
      "Home Living",
      "Health & Beauty",
      "Groceries",
      "Entertainment"
    ];
  }
}