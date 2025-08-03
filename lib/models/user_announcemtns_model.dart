import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAnnouncementsModel {
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

  // Fetch all announcements for a barangay
  Future<List<Map<String, dynamic>>> fetchAllAnnouncements(String barangay) async {
    if (barangay.isEmpty) return [];

    final List<Map<String, dynamic>> allAnnouncements = [];

    try {
      // 1. Fetch from general announcements collection
      final generalAnnouncementsQuery = await _firestore
          .collection('announcements')
          .where('barangay', isEqualTo: barangay)
          .get();

      for (final doc in generalAnnouncementsQuery.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        data['source'] = 'general';
        allAnnouncements.add(data);
      }

      // 2. Fetch admin announcements from users with role 'admin' and matching barangay
      final adminUsersQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .where('barangay', isEqualTo: barangay)
          .get();

      for (final adminUser in adminUsersQuery.docs) {
        final adminAnnouncementsQuery = await _firestore
            .collection('users')
            .doc(adminUser.id)
            .collection('announcements')
            .get();

        for (final announcementDoc in adminAnnouncementsQuery.docs) {
          final data = announcementDoc.data();
          data['id'] = announcementDoc.id;
          data['source'] = 'admin';
          data['adminId'] = adminUser.id;
          allAnnouncements.add(data);
        }
      }

      // 3. Sort all announcements by timestamp (most recent first)
      allAnnouncements.sort((a, b) {
        final timestampA = a['timestamp'] as Timestamp?;
        final timestampB = b['timestamp'] as Timestamp?;
        
        if (timestampA == null && timestampB == null) return 0;
        if (timestampA == null) return 1;
        if (timestampB == null) return -1;
        
        return timestampB.compareTo(timestampA);
      });

      return allAnnouncements;
    } catch (e) {
      print('Error fetching announcements: $e');
      return [];
    }
  }
}