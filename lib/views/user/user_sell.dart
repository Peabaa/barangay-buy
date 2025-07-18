import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';
import 'user_announcements.dart';
import 'user_posted_announcement.dart';
import 'user_profile.dart';
import 'home_header_footer.dart';

class UserSell extends StatefulWidget {
  const UserSell({super.key});

  @override
  State<UserSell> createState() => _UserSellState();
}

class _UserSellState extends State<UserSell> {
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
          // Announcements header
          Padding(
            padding: EdgeInsets.only(
              top: relHeight(34),
              left: relWidth(24),
              right: relWidth(24),
              bottom: relHeight(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Sell Page / Item Postings',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: relWidth(16),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF611A04),
                    letterSpacing: 0.32,
                    height: 1.17182,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Announcements list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedBarangay.isEmpty
                  ? null
                  : FirebaseFirestore.instance
                      .collection('announcements')
                      .where('barangay', isEqualTo: selectedBarangay)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (selectedBarangay.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: relHeight(10)),
                        Container(
                          width: relWidth(321),
                          padding: EdgeInsets.fromLTRB(
                            relWidth(10.125),
                            relHeight(40.125),
                            relWidth(40.125),
                            relHeight(8.75),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Image.asset(
                              'assets/images/noannounce.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: relHeight(10)),
                        Container(
                          width: relWidth(249),
                          height: relHeight(26),
                          alignment: Alignment.center,
                          child: Text(
                            'No Announcements Yet.',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: relWidth(16),
                              fontWeight: FontWeight.w500,
                              color: const Color(0x88888888),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  padding: EdgeInsets.only(top: relHeight(10), right: relWidth(20)),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return Center(
                      child: UserPostedAnnouncement(
                        text: data['text'] ?? '',
                        username: data['username'] ?? 'Unknown',
                        timestamp: data['timestamp'],
                        relWidth: relWidth,
                        relHeight: relHeight,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
        activeTab: 'sell',
      ),
    );
  }
}


