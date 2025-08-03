import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeHeaderFooterModel {
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
        return userDoc.data()?['barangay'] ?? 'Banilad';
      }
      return 'Banilad';
    } catch (e) {
      print('Error getting user barangay: $e');
      return 'Banilad';
    }
  }

  // Get notification count for current user
  Future<int> getNotificationCount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final notificationsQuery = await _firestore
            .collection('notifications')
            .where('userId', isEqualTo: user.uid)
            .where('read', isEqualTo: false)
            .get();
        return notificationsQuery.docs.length;
      }
      return 0;
    } catch (e) {
      print('Error getting notification count: $e');
      return 0;
    }
  }
}