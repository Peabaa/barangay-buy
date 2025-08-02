import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barangay_buy/views/user/home_header_footer.dart';
import 'package:barangay_buy/views/user/home.dart';
import 'package:barangay_buy/views/user/user_announcements.dart';
import 'package:barangay_buy/views/user/user_sell.dart';

class UserNotificationsScreen extends StatefulWidget {
  const UserNotificationsScreen({super.key});

  @override
  State<UserNotificationsScreen> createState() => _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends State<UserNotificationsScreen> {
  String selectedBarangay = '';
  String? currentUserId;
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  double relWidth(BuildContext context, double dp) => MediaQuery.of(context).size.width * (dp / 412);
  double relHeight(BuildContext context, double dp) => MediaQuery.of(context).size.height * (dp / 915);

  @override
  void initState() {
    super.initState();
    _fetchUserBarangayAndNotifications();
  }

  Future<void> _fetchUserBarangayAndNotifications() async {
    await _fetchUserBarangay();
    await _fetchNotifications();
  }

  Future<void> _fetchUserBarangay() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        selectedBarangay = userDoc.data()?['barangay'] ?? '';
      });
    }
  }

  Future<void> _fetchNotifications() async {
    if (currentUserId == null || selectedBarangay.isEmpty) return;
    
    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, dynamic>> allNotifications = [];

      // Fetch notifications from the notifications collection
      final notificationsQuery = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: currentUserId)
          .limit(50)
          .get();

      for (var notificationDoc in notificationsQuery.docs) {
        final notificationData = notificationDoc.data();
        allNotifications.add({
          'type': notificationData['type'],
          'timestamp': notificationData['timestamp'],
          'username': notificationData['username'] ?? 'Unknown',
          'productName': notificationData['productName'] ?? '',
          'comment': notificationData['comment'] ?? '',
          'reply': notificationData['reply'] ?? '',
          'title': notificationData['title'] ?? '',
          'color': _getNotificationColor(notificationData['type']),
        });
      }

      // Fetch announcements from admin users in the same barangay
      print('Fetching admin announcements for barangay: $selectedBarangay');
      final adminUsersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .where('barangay', isEqualTo: selectedBarangay)
          .get();

      print('Found ${adminUsersQuery.docs.length} admin users');
      for (final adminUser in adminUsersQuery.docs) {
        final adminData = adminUser.data();
        final adminUsername = adminData['username'] ?? 'Barangay Official';
        print('Checking announcements for admin: $adminUsername (${adminUser.id})');
        
        final adminAnnouncementsQuery = await FirebaseFirestore.instance
            .collection('users')
            .doc(adminUser.id)
            .collection('announcements')
            .limit(20)
            .get();

        print('Found ${adminAnnouncementsQuery.docs.length} announcements for admin: $adminUsername');
        for (final announcementDoc in adminAnnouncementsQuery.docs) {
          final announcementData = announcementDoc.data();
          print('Adding announcement: ${announcementData['text'] ?? 'No text'}');
          
          allNotifications.add({
            'type': 'announcement',
            'timestamp': announcementData['timestamp'],
            'username': adminUsername,
            'productName': '',
            'comment': '',
            'reply': '',
            'title': announcementData['text'] ?? announcementData['title'] ?? 'New Announcement',
            'color': _getNotificationColor('announcement'),
          });
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

      print('Total notifications found: ${allNotifications.length}');
      setState(() {
        notifications = allNotifications;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  int _getNotificationColor(String type) {
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

  // Helper method to create notifications (can be called from other parts of the app)
  static Future<void> createNotification({
    required String userId,
    required String type,
    required String username,
    String? productName,
    String? comment,
    String? reply,
    String? title,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
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

  // Helper method to create announcement notifications for all users in a barangay
  static Future<void> createAnnouncementNotifications({
    required String adminUserId,
    required String barangay,
    required String title,
    required String adminUsername,
  }) async {
    try {
      // Get all users in the same barangay (excluding the admin who posted)
      final usersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('barangay', isEqualTo: barangay)
          .where('role', isNotEqualTo: 'admin')
          .get();

      // Create notification for each user
      final batch = FirebaseFirestore.instance.batch();
      for (var userDoc in usersQuery.docs) {
        final notificationRef = FirebaseFirestore.instance.collection('notifications').doc();
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

  String _formatTimestamp(Timestamp? timestamp) {
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

  List<Map<String, dynamic>> _getTodayNotifications() {
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

  List<Map<String, dynamic>> _getYesterdayNotifications() {
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

  Widget _buildNotificationItem(Map<String, dynamic> notification, double Function(double) relWidth, double Function(double) relHeight) {
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

    return Center(
      child: Container(
        width: relWidth(334.0),
        constraints: BoxConstraints(
          minHeight: relHeight(96.0),
        ),
        decoration: BoxDecoration(
          color: Color(notification['color']),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color.fromRGBO(0, 0, 0, 0.22),
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(relWidth(12.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: relWidth(334.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(11.0),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      letterSpacing: 0.22,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: relHeight(6.0)),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF611A04),
                        fontFamily: 'Roboto',
                        fontSize: relWidth(11.0),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        letterSpacing: 0.22,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: relHeight(4.0)),
            Text(
              _formatTimestamp(notification['timestamp']),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.31),
                fontFamily: 'Roboto',
                fontSize: relWidth(10.0),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                height: 1.17164,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFF5B29),
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFFF5B29),
                child: HomeHeader(
                  relWidth: relWidth,
                  relHeight: relHeight,
                  selectedBarangay: selectedBarangay.isNotEmpty ? selectedBarangay : 'Banilad',
                  onNotificationTap: null,
                ),
              ),
            ),
            if (isLoading) ...[
              SizedBox(height: relHeight(100.0)),
              Center(child: CircularProgressIndicator()),
            ] else if (notifications.isNotEmpty) ...[
              SizedBox(height: relHeight(25.0)),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: relWidth(25.0)),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Color(0xFF611A04),
                    fontFamily: 'Roboto',
                    fontSize: relWidth(16.0),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 1.17182,
                    letterSpacing: 0.32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: relHeight(10.0)),
              
              // TODAY NOTIFICATIONS
              ...() {
                final todayNotifications = _getTodayNotifications();
                if (todayNotifications.isEmpty) return <Widget>[];
                
                return [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: relWidth(39.0)),
                    child: Text(
                      'TODAY',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: relWidth(14.0),
                        color: Color(0xFF611A04),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(12.0)),
                  ...todayNotifications.map((notification) => Padding(
                    padding: EdgeInsets.only(bottom: relHeight(12.0)),
                    child: _buildNotificationItem(notification, relWidth, relHeight),
                  )).toList(),
                  SizedBox(height: relHeight(16.0)),
                ];
              }(),
              
              // YESTERDAY NOTIFICATIONS
              ...() {
                final yesterdayNotifications = _getYesterdayNotifications();
                if (yesterdayNotifications.isEmpty) return <Widget>[];
                
                return [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: relWidth(39.0)),
                    child: Text(
                      'YESTERDAY',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: relWidth(14.0),
                        color: Color(0xFF611A04),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(12.0)),
                  ...yesterdayNotifications.map((notification) => Padding(
                    padding: EdgeInsets.only(bottom: relHeight(12.0)),
                    child: _buildNotificationItem(notification, relWidth, relHeight),
                  )).toList(),
                  SizedBox(height: relHeight(16.0)),
                ];
              }(),
              
              // OLDER NOTIFICATIONS
              ...() {
                final olderNotifications = notifications.where((notification) {
                  final timestamp = notification['timestamp'] as Timestamp?;
                  if (timestamp == null) return false;
                  final notificationDate = timestamp.toDate();
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final yesterday = DateTime(now.year, now.month, now.day - 1);
                  final notificationDay = DateTime(notificationDate.year, notificationDate.month, notificationDate.day);
                  return !notificationDay.isAtSameMomentAs(today) && !notificationDay.isAtSameMomentAs(yesterday);
                }).toList();
                
                if (olderNotifications.isEmpty) return <Widget>[];
                
                return [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: relWidth(39.0)),
                    child: Text(
                      'EARLIER',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: relWidth(14.0),
                        color: Color(0xFF611A04),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(12.0)),
                  ...olderNotifications.map((notification) => Padding(
                    padding: EdgeInsets.only(bottom: relHeight(12.0)),
                    child: _buildNotificationItem(notification, relWidth, relHeight),
                  )).toList(),
                ];
              }(),
              
              SizedBox(height: relHeight(30.0)),
            ] else ...[
              SizedBox(height: relHeight(115.0)),
              Center(
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    width: relWidth(283.0),
                    height: relWidth(283.0),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/nonotif.png',
                      width: relWidth(283.0),
                      height: relWidth(283.0),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: relHeight(20.0)),
              Center(
                child: Text(
                  'No Notifications Here',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontStyle: FontStyle.italic,
                    fontSize: relWidth(20.0),
                    fontWeight: FontWeight.w500,
                    color: const Color(0x88888888),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: HomeFooter(
        relWidth: relWidth,
        relHeight: relHeight,
        onStoreTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
        onAnnouncementTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UserAnnouncements(),
            ),
          );
        },
        onSellTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UserSell(),
            ),
          );
        },
        onProfileTap: () {
          Navigator.of(context).pop();
        },
        activeTab: 'none', // No tab is selected
      ),
    );
  }
}
