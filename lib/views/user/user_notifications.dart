import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barangay_buy/views/user/home_header_footer.dart';
import 'package:barangay_buy/views/user/home.dart';
import 'package:barangay_buy/views/user/user_announcements.dart';
import 'package:barangay_buy/views/user/user_sell.dart';
import '../../controllers/user_notifications_controller.dart';

class UserNotificationsScreen extends StatefulWidget {
  const UserNotificationsScreen({super.key});

  @override
  State<UserNotificationsScreen> createState() => _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends State<UserNotificationsScreen> {
  final UserNotificationsController _controller = UserNotificationsController();
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
    currentUserId = _controller.getCurrentUserId();
    if (currentUserId != null) {
      final barangay = await _controller.getCurrentUserBarangay();
      setState(() {
        selectedBarangay = barangay;
      });
    }
  }

  Future<void> _fetchNotifications() async {
    if (currentUserId == null || selectedBarangay.isEmpty) return;
    
    setState(() {
      isLoading = true;
    });

    try {
      final allNotifications = await _controller.fetchAllNotifications(currentUserId!, selectedBarangay);
      
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

  Widget _buildNotificationItem(Map<String, dynamic> notification, double Function(double) relWidth, double Function(double) relHeight) {
    final content = _controller.getNotificationContent(notification);
    final title = content['title']!;
    final subtitle = content['subtitle']!;

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
              _controller.formatTimestamp(notification['timestamp']),
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

    _controller.setSystemUIOverlayStyle();

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
                final todayNotifications = _controller.getTodayNotifications(notifications);
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
                final yesterdayNotifications = _controller.getYesterdayNotifications(notifications);
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
                final olderNotifications = _controller.getOlderNotifications(notifications);
                
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
        onStoreTap: () => _controller.navigateToHome(context),
        onAnnouncementTap: () => _controller.navigateToAnnouncements(context),
        onSellTap: () => _controller.navigateToSell(context),
        onProfileTap: () => _controller.navigateToProfile(context),
        activeTab: 'none', // No tab is selected
      ),
    );
  }
}
