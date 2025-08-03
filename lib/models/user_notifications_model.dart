import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserNotificationsModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

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

  // Fetch notifications from notifications collection
  Future<List<Map<String, dynamic>>> fetchUserNotifications(String userId) async {
    try {
      final notificationsQuery = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .limit(50)
          .get();

      return notificationsQuery.docs.map((doc) {
        final data = doc.data();
        return {
          'type': data['type'],
          'timestamp': data['timestamp'],
          'username': data['username'] ?? 'Unknown',
          'productName': data['productName'] ?? '',
          'comment': data['comment'] ?? '',
          'reply': data['reply'] ?? '',
          'title': data['title'] ?? '',
        };
      }).toList();
    } catch (e) {
      print('Error fetching user notifications: $e');
      return [];
    }
  }

  // Fetch admin announcements from the same barangay
  Future<List<Map<String, dynamic>>> fetchAdminAnnouncements(String barangay) async {
    try {
      List<Map<String, dynamic>> announcements = [];

      final adminUsersQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .where('barangay', isEqualTo: barangay)
          .get();

      for (final adminUser in adminUsersQuery.docs) {
        final adminData = adminUser.data();
        final adminUsername = adminData['username'] ?? 'Barangay Official';
        
        final adminAnnouncementsQuery = await _firestore
            .collection('users')
            .doc(adminUser.id)
            .collection('announcements')
            .limit(20)
            .get();

        for (final announcementDoc in adminAnnouncementsQuery.docs) {
          final announcementData = announcementDoc.data();
          
          announcements.add({
            'type': 'announcement',
            'timestamp': announcementData['timestamp'],
            'username': adminUsername,
            'productName': '',
            'comment': '',
            'reply': '',
            'title': announcementData['text'] ?? announcementData['title'] ?? 'New Announcement',
          });
        }
      }

      return announcements;
    } catch (e) {
      print('Error fetching admin announcements: $e');
      return [];
    }
  }

  // Create notification
  Future<void> createNotification({
    required String userId,
    required String type,
    required String username,
    String? productName,
    String? comment,
    String? reply,
    String? title,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'type': type,
        'username': username,
        'productName': productName,
        'comment': comment,
        'reply': reply,
        'title': title,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      print('Error creating notification: $e');
    }
  }

  // Create announcement notifications for all users in a barangay
  Future<void> createAnnouncementNotifications({
    required String adminUserId,
    required String barangay,
    required String title,
    required String adminUsername,
  }) async {
    try {
      final usersQuery = await _firestore
          .collection('users')
          .where('barangay', isEqualTo: barangay)
          .where('role', isNotEqualTo: 'admin')
          .get();

      final batch = _firestore.batch();
      for (var userDoc in usersQuery.docs) {
        final notificationRef = _firestore.collection('notifications').doc();
        batch.set(notificationRef, {
          'userId': userDoc.id,
          'type': 'announcement',
          'username': adminUsername,
          'productName': '',
          'comment': '',
          'reply': '',
          'title': title,
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
        });
      }
      
      await batch.commit();
    } catch (e) {
      print('Error creating announcement notifications: $e');
    }
  }
}