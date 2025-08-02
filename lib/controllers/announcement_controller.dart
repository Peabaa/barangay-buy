import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/announcement_model.dart';

class AnnouncementController {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Get announcements stream for current admin
  static Stream<List<AnnouncementModel>> getAnnouncementsStream() {
    final user = currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('announcements')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AnnouncementModel.fromFirestore(doc))
          .toList();
    });
  }

  // Create new announcement
  static Future<void> createAnnouncement({
    required String text,
    required String barangay,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    if (text.trim().isEmpty) {
      throw Exception('Announcement text cannot be empty');
    }

    try {
      // Get username from user document
      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      final username = userDoc.data()?['username'] ?? user.email ?? 'Unknown';

      final announcement = AnnouncementModel(
        id: '', // Will be set by Firestore
        text: text.trim(),
        username: username,
        barangay: barangay,
        adminEmail: user.email ?? '',
        timestamp: null, // Will be set by server
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('announcements')
          .add(announcement.toFirestore());
    } catch (e) {
      throw Exception('Failed to create announcement: $e');
    }
  }

  // Delete announcement
  static Future<void> deleteAnnouncement(String announcementId) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('announcements')
          .doc(announcementId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete announcement: $e');
    }
  }

  // Update announcement
  static Future<void> updateAnnouncement({
    required String announcementId,
    required String text,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    if (text.trim().isEmpty) {
      throw Exception('Announcement text cannot be empty');
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('announcements')
          .doc(announcementId)
          .update({'text': text.trim()});
    } catch (e) {
      throw Exception('Failed to update announcement: $e');
    }
  }

  // Filter announcements based on search query
  static List<AnnouncementModel> filterAnnouncements(
    List<AnnouncementModel> announcements,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) {
      return announcements;
    }

    final query = searchQuery.toLowerCase();
    return announcements.where((announcement) {
      final text = announcement.text.toLowerCase();
      final username = announcement.username.toLowerCase();
      return text.contains(query) || username.contains(query);
    }).toList();
  }
}
