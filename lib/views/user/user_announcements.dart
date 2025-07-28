import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';
import 'user_posted_announcement.dart';
import 'user_sell.dart';
import 'user_profile.dart';
import 'home_header_footer.dart';
class UserAnnouncements extends StatefulWidget {
  const UserAnnouncements({super.key});

  @override
  State<UserAnnouncements> createState() => _UserAnnouncementsState();
}

class _UserAnnouncementsState extends State<UserAnnouncements> {
  String selectedBarangay = '';
  Future<List<Map<String, dynamic>>>? _announcementsFuture;

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
        // Update the future when barangay changes
        if (selectedBarangay.isNotEmpty) {
          _announcementsFuture = _fetchAllAnnouncements();
        }
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAllAnnouncements() async {
    if (selectedBarangay.isEmpty) return [];

    final List<Map<String, dynamic>> allAnnouncements = [];

    try {
      // 1. Fetch from general announcements collection
      final generalAnnouncementsQuery = await FirebaseFirestore.instance
          .collection('announcements')
          .where('barangay', isEqualTo: selectedBarangay)
          .get();

      for (final doc in generalAnnouncementsQuery.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        data['source'] = 'general';
        allAnnouncements.add(data);
      }

      // 2. Fetch admin announcements from users with role 'admin' and matching barangay
      final adminUsersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .where('barangay', isEqualTo: selectedBarangay)
          .get();

      for (final adminUser in adminUsersQuery.docs) {
        final adminAnnouncementsQuery = await FirebaseFirestore.instance
            .collection('users')
            .doc(adminUser.id)
            .collection('announcements')
            .get();

        for (final announcementDoc in adminAnnouncementsQuery.docs) {
          final data = announcementDoc.data();
          data['id'] = announcementDoc.id;
          data['source'] = 'admin';
          data['adminId'] = adminUser.id;
          allAnnouncements.add(data);
        }
      }

      // 3. Sort all announcements by timestamp (most recent first)
      allAnnouncements.sort((a, b) {
        final timestampA = a['timestamp'] as Timestamp?;
        final timestampB = b['timestamp'] as Timestamp?;
        
        if (timestampA == null && timestampB == null) return 0;
        if (timestampA == null) return 1;
        if (timestampB == null) return -1;
        
        return timestampB.compareTo(timestampA);
      });

      return allAnnouncements;
    } catch (e) {
      // Handle error silently or use proper logging
      return [];
    }
  }

  Future<void> _refreshAnnouncements() async {
    if (selectedBarangay.isNotEmpty) {
      setState(() {
        _announcementsFuture = _fetchAllAnnouncements();
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
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                          'Announcements',
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: selectedBarangay.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : FutureBuilder<List<Map<String, dynamic>>>(
                            future: _announcementsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                              final announcements = snapshot.data!;
                              return RefreshIndicator(
                                onRefresh: _refreshAnnouncements,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(top: relHeight(10), right: relWidth(20)),
                                  itemCount: announcements.length,
                                  itemBuilder: (context, index) {
                                    final data = announcements[index];
                                    return Center(
                                      child: UserPostedAnnouncement(
                                        text: data['text'] ?? '',
                                        username: data['username'] ?? 'Unknown',
                                        timestamp: data['timestamp'],
                                        relWidth: relWidth,
                                        relHeight: relHeight,
                                        isAdmin: data['source'] == 'admin',
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
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
        activeTab: 'announcements',
      ),
    );
  }
}


