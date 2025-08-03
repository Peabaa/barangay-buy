import 'package:cloud_firestore/cloud_firestore.dart';

class UserPostedAnnouncementModel {
  // Get formatted timestamp from Firestore Timestamp
  String getFormattedTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateUtc = timestamp.toDate();
      final date = dateUtc.toLocal();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final month = months[date.month - 1];
      int hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final ampm = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return '$month ${date.day}, ${date.year}, $hour:$minute $ampm';
    } catch (e) {
      return '';
    }
  }

  // Validate announcement data
  bool isValidAnnouncement(String text, String username) {
    return text.trim().isNotEmpty && username.trim().isNotEmpty;
  }

  // Get default user avatar path
  String getDefaultUserAvatarPath() {
    return 'assets/images/UserCircle.png';
  }
}