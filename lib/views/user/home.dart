import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_header_footer.dart';
import 'user_announcements.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedBarangay = '';

  @override
  void initState() {
    super.initState();
    _fetchBarangay();
  }

  Future<void> _fetchBarangay() async {
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
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFF5B29),
              child: HomeHeader(
                relWidth: relWidth,
                relHeight: relHeight,
                selectedBarangay: selectedBarangay,
                onNotificationTap: () {
                  print('Notification tapped');
                },
              ),
            ),
          ),
          // ...rest of your home page content...
        ],
      ),
      bottomNavigationBar: HomeFooter(
        relWidth: relWidth,
        relHeight: relHeight,
        onStoreTap: () {
          print('Store button tapped');
        },
        onAnnouncementTap: () {
          print('Announcement button tapped');

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserAnnouncements(),
            ),
          );
        },
      ),
    );
  }
}