import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_notifications_model.dart';
import '../views/user/home.dart';
import '../views/user/user_announcements.dart';
import '../views/user/user_sell.dart';

class UserNotificationsController {
  final UserNotificationsModel _model = UserNotificationsModel();

  // Get current user ID
  String? getCurrentUserId() {
    return _model.getCurrentUserId();
  }

  // Get current user's barangay
  Future<String> getCurrentUserBarangay() async {
    return await _model.getCurrentUserBarangay();
  }

  // Fetch all notifications (user notifications + admin announcements)
  Future<List<Map<String, dynamic>>> fetchAllNotifications(String userId, String barangay) async {
    try {
      List<Map<String, dynamic>> allNotifications = [];

      // Fetch user notifications
      final userNotifications = await _model.fetchUserNotifications(userId);
      for (final notification in userNotifications) {
        notification['color'] = getNotificationColor(notification['type']);
        allNotifications.add(notification);
      }

      // Fetch admin announcements
      if (barangay.isNotEmpty) {
        final adminAnnouncements = await _model.fetchAdminAnnouncements(barangay);
        for (final announcement in adminAnnouncements) {
          announcement['color'] = getNotificationColor(announcement['type']);
          allNotifications.add(announcement);
        }
      }

      // Sort all notifications by timestamp
      allNotifications.sort((a, b) {
        final aTime = a['timestamp'] as Timestamp?;
        final bTime = b['timestamp'] as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      return allNotifications;
    } catch (e) {
      print('Error fetching all notifications: $e');
      return [];
    }
  }

  // Get notification color based on type
  int getNotificationColor(String type) {
    switch (type) {
      case 'comment':
        return 0x7A53FFBA;
      case 'favorite':
        return 0x7329FF29;
      case 'announcement':
        return 0xFFF7B6B6;
      case 'reply':
        return 0xFFFFFFB6;
      default:
        return 0xFFE0E0E0;
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
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // Filter notifications by day
  List<Map<String, dynamic>> getTodayNotifications(List<Map<String, dynamic>> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return notifications.where((notification) {
      final timestamp = notification['timestamp'] as Timestamp?;
      if (timestamp == null) return false;
      final notificationDate = timestamp.toDate();
      final notificationDay = DateTime(notificationDate.year, notificationDate.month, notificationDate.day);
      return notificationDay.isAtSameMomentAs(today);
    }).toList();
  }

  List<Map<String, dynamic>> getYesterdayNotifications(List<Map<String, dynamic>> notifications) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    
    return notifications.where((notification) {
      final timestamp = notification['timestamp'] as Timestamp?;
      if (timestamp == null) return false;
      final notificationDate = timestamp.toDate();
      final notificationDay = DateTime(notificationDate.year, notificationDate.month, notificationDate.day);
      return notificationDay.isAtSameMomentAs(yesterday);
    }).toList();
  }

  List<Map<String, dynamic>> getOlderNotifications(List<Map<String, dynamic>> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    
    return notifications.where((notification) {
      final timestamp = notification['timestamp'] as Timestamp?;
      if (timestamp == null) return false;
      final notificationDate = timestamp.toDate();
      final notificationDay = DateTime(notificationDate.year, notificationDate.month, notificationDate.day);
      return !notificationDay.isAtSameMomentAs(today) && !notificationDay.isAtSameMomentAs(yesterday);
    }).toList();
  }

  // Get notification title and subtitle
  Map<String, String> getNotificationContent(Map<String, dynamic> notification) {
    String title = '';
    String subtitle = '';
    
    switch (notification['type']) {
      case 'comment':
        title = 'Someone commented on your listing\n[${notification['productName']}]';
        subtitle = '${notification['username']}: "${notification['comment']}"';
        break;
      case 'favorite':
        title = 'Someone liked your listing [${notification['productName']}]';
        subtitle = notification['username'];
        break;
      case 'announcement':
        title = '${notification['username']} posted an announcement';
        subtitle = notification['title'];
        break;
      case 'reply':
        title = '${notification['username']} replied to your comment on\n[${notification['productName']}]';
        subtitle = '${notification['username']}: ${notification['reply']}';
        break;
    }

    return {'title': title, 'subtitle': subtitle};
  }

  // Set system UI overlay style
  void setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFF5B29),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // Navigation methods
  void navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void navigateToAnnouncements(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const UserAnnouncements(),
      ),
    );
  }

  void navigateToSell(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const UserSell(),
      ),
    );
  }

  void navigateToProfile(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Static helper methods for creating notifications (same as original)
  static Future<void> createNotification({
    required String userId,
    required String type,
    required String username,
    String? productName,
    String? comment,
    String? reply,
    String? title,
  }) async {
    final model = UserNotificationsModel();
    await model.createNotification(
      userId: userId,
      type: type,
      username: username,
      productName: productName,
      comment: comment,
      reply: reply,
      title: title,
    );
  }

  static Future<void> createAnnouncementNotifications({
    required String adminUserId,
    required String barangay,
    required String title,
    required String adminUsername,
  }) async {
    final model = UserNotificationsModel();
    await model.createAnnouncementNotifications(
      adminUserId: adminUserId,
      barangay: barangay,
      title: title,
      adminUsername: adminUsername,
    );
  }
}