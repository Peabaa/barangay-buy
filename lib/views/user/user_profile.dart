import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';
import 'user_announcements.dart';
import 'user_posted_announcement.dart';
import 'user_sell.dart';
import 'home_header_footer.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String selectedBarangay = '';
  String username = '';
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        selectedBarangay = userDoc.data()?['barangay'] ?? '';
        username = userDoc.data()?['username'] ?? '';
        email = userDoc.data()?['email'] ?? '';
        password = userDoc.data()?['password'] ?? '';
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
      body: SingleChildScrollView( // <-- Make scrollable for small screens
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
                  selectedBarangay: selectedBarangay,
                  onNotificationTap: () {},
                ),
              ),
            ),
            // Centered user.png
            Padding(
              padding: EdgeInsets.only(top: relHeight(10)),
              child: Center(
                child: Container(
                  width: relWidth(231),
                  height: relWidth(231),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/UserProfilePage.png',
                    width: relWidth(231),
                    height: relWidth(231),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: relHeight(9)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: relWidth(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(24),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 1.17182,
                      letterSpacing: 0.48,
                    ),
                  ),
                  SizedBox(height: relHeight(7)),
                  Container(
                    width: relWidth(299),
                    height: relHeight(17),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      username.isNotEmpty ? username : '',
                      style: TextStyle(
                        color: const Color(0xFF611A04),
                        fontFamily: 'Roboto',
                        fontSize: relWidth(16),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: 1.17176,
                        letterSpacing: 0.32,
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(3)),
                  Container(
                    width: relWidth(363),
                    height: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color.fromRGBO(97, 26, 4, 0.24),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(16)),
                  Text(
                    'Email Address',
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(24),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 1.17182,
                      letterSpacing: 0.48,
                    ),
                  ),
                  SizedBox(height: relHeight(7)),
                  Container(
                    width: relWidth(299),
                    height: relHeight(20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      email.isNotEmpty ? email : '',
                      style: TextStyle(
                        color: const Color(0xFF611A04),
                        fontFamily: 'Roboto',
                        fontSize: relWidth(16),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: 1.17176,
                        letterSpacing: 0.32,
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(3)),
                  Container(
                    width: relWidth(363),
                    height: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color.fromRGBO(97, 26, 4, 0.24),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(16)),
                  Text(
                    'Password',
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(24),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 1.17182,
                      letterSpacing: 0.48,
                    ),
                  ),
                  SizedBox(height: relHeight(7)),
                  Container(
                    width: relWidth(299),
                    height: relHeight(17),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      password.isNotEmpty ? '*' * password.length : '',
                      style: TextStyle(
                        color: const Color(0xFF611A04),
                        fontFamily: 'Roboto',
                        fontSize: relWidth(16),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: 1.17176,
                        letterSpacing: 0.32,
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(3)),
                  Container(
                    width: relWidth(363),
                    height: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color.fromRGBO(97, 26, 4, 0.24),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(16)),
                  Text(
                    'Barangay',
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(24),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 1.17182,
                      letterSpacing: 0.48,
                    ),
                  ),
                  SizedBox(height: relHeight(7)),
                  Row(
                    children: [
                      Container(
                        width: relWidth(299),
                        height: relHeight(17),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedBarangay.isNotEmpty ? selectedBarangay : '',
                          style: TextStyle(
                            color: const Color(0xFF611A04),
                            fontFamily: 'Roboto',
                            fontSize: relWidth(16),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            height: 1.17176,
                            letterSpacing: 0.32,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          // TODO: Add your barangay change logic here
                        },
                        child: Image.asset(
                          'assets/images/arrow-left.png',
                          width: relWidth(24),
                          height: relWidth(24),
                          color: const Color(0xFF7B3F27),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: relHeight(3)),
                  Container(
                    width: relWidth(363),
                    height: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color.fromRGBO(97, 26, 4, 0.24),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(16)),
                  Center(
                    child: Container(
                      width: relWidth(183),
                      height: relHeight(38),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B3F27), // Use the brown color from your sample
                        borderRadius: BorderRadius.circular(6), // Slightly more rounded corners
                      ),
                      child: Center(
                        child: Text(
                          'Save Changes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: relWidth(24),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.48,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UserProfile(),
            ),
          );
        },
        activeTab: 'profile',
      ),
    );
  }
}


