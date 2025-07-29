import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barangay_buy/views/user/home_header_footer.dart';
import 'package:barangay_buy/views/user/home.dart';
import 'package:barangay_buy/views/user/user_announcements.dart';
import 'package:barangay_buy/views/user/user_sell.dart';
import '../login_signup.dart';

class UserNotificationsScreen extends StatefulWidget {
  const UserNotificationsScreen({Key? key}) : super(key: key);

  @override
  State<UserNotificationsScreen> createState() => _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends State<UserNotificationsScreen> {
  String selectedBarangay = '';
  // Toggle this to switch between notification blocks and no notifications state
  bool hasNotifications = true;

  double relWidth(BuildContext context, double dp) => MediaQuery.of(context).size.width * (dp / 412);
  double relHeight(BuildContext context, double dp) => MediaQuery.of(context).size.height * (dp / 915);

  @override
  void initState() {
    super.initState();
    _fetchUserBarangay();
  }

  Future<void> _fetchUserBarangay() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        selectedBarangay = userDoc.data()?['barangay'] ?? '';
      });
    }
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
            if (hasNotifications) ...[
              SizedBox(height: relHeight(25)),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: relWidth(25)),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Color(0xFF611A04),
                    fontFamily: 'Roboto',
                    fontSize: relWidth(16),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 1.17182,
                    letterSpacing: 0.32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: relHeight(10)),
              // TODAY
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: relWidth(39)),
                child: Text(
                  'TODAY',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: relWidth(14),
                    color: Color(0xFF611A04),
                  ),
                ),
              ),
              SizedBox(height: relHeight(12)),
              // Notification 1
              Center(
                child: Container(
                  width: relWidth(334),
                  height: relHeight(96),
                  decoration: BoxDecoration(
                    color: Color(0x7A53FFBA), // rgba(83,255,186,0.48)
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color.fromRGBO(0, 0, 0, 0.22),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(relWidth(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: relWidth(334),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Someone commented on your listing\n[Matcha Obssessed Tshirt]',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF611A04),
                                fontFamily: 'Roboto',
                                fontSize: relWidth(11),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: 0.22,
                              ),
                            ),
                            SizedBox(height: relHeight(6)),
                            Text(
                              'Kanye West: "Is this available in size XL?"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF611A04),
                                fontFamily: 'Roboto',
                                fontSize: relWidth(11),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: 0.22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: relHeight(4)),
                      Text(
                        '1 hour ago',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.31),
                          fontFamily: 'Roboto',
                          fontSize: relWidth(10),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          height: 1.17164,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: relHeight(12)),
              // Notification 2
              Center(
                child: Container(
                  width: relWidth(334),
                  height: relHeight(96),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7B6B6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color.fromRGBO(0, 0, 0, 0.22),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(relWidth(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: relWidth(334),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Official_BrgyTisa posted an announcement',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF611A04),
                                fontFamily: 'Roboto',
                                fontSize: relWidth(11),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: 0.22,
                              ),
                            ),
                            SizedBox(height: relHeight(6)),
                            Text(
                              'Check it out!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF611A04),
                                fontFamily: 'Roboto',
                                fontSize: relWidth(11),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: 0.22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: relHeight(4)),
                      Text(
                        '1 hour ago',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.31),
                          fontFamily: 'Roboto',
                          fontSize: relWidth(10),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          height: 1.17164,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: relHeight(16)),
              // YESTERDAY
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: relWidth(39)),
                child: Text(
                  'YESTERDAY',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: relWidth(14),
                    color: Color(0xFF611A04),
                  ),
                ),
              ),
              SizedBox(height: relHeight(12)),
              // Notification 3
              Center(
                child: Container(
                  width: relWidth(334),
                  height: relHeight(96),
                  decoration: BoxDecoration(
                    color: Color(0x7329FF29), 
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color.fromRGBO(0, 0, 0, 0.22),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(relWidth(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: relWidth(334),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Someone liked your listing [Matcha Obssessed Tshirt]',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF611A04),
                                fontFamily: 'Roboto',
                                fontSize: relWidth(11),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: 0.22,
                              ),
                            ),
                            SizedBox(height: relHeight(6)),
                            Text(
                              'Kanye West',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF611A04),
                                fontFamily: 'Roboto',
                                fontSize: relWidth(11),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: 0.22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: relHeight(4)),
                      Text(
                        'Yesterday, 5:30 PM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.31),
                          fontFamily: 'Roboto',
                          fontSize: relWidth(10),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          height: 1.17164,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: relHeight(12)),
              // Notification 4
              Center(
                child: Container(
                  width: relWidth(334),
                  height: relHeight(96),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFB6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color.fromRGBO(0, 0, 0, 0.22),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(relWidth(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: relWidth(334),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Donald Trump replied to your comment on\n[Florence Perfumes]',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF611A04),
                                fontFamily: 'Roboto',
                                fontSize: relWidth(11),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: 0.22,
                              ),
                            ),
                            SizedBox(height: relHeight(6)),
                            Text(
                              'Donald Trump: You can pay through cash or GCash',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF611A04),
                                fontFamily: 'Roboto',
                                fontSize: relWidth(11),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                letterSpacing: 0.22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: relHeight(4)),
                      Text(
                        'Yesterday, 2:15 PM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.31),
                          fontFamily: 'Roboto',
                          fontSize: relWidth(10),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          height: 1.17164,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: relHeight(30)),
            ] else ...[
              SizedBox(height: relHeight(115)),
              Center(
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    width: relWidth(283),
                    height: relWidth(283),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/nonotif.png',
                      width: relWidth(283),
                      height: relWidth(283),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: relHeight(20)),
              Center(
                child: Text(
                  'No Notifications Here',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontStyle: FontStyle.italic,
                    fontSize: relWidth(20),
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
