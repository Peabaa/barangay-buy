import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_posted_announcement.dart';
import 'home_header_footer.dart';
import '../../controllers/user_announcements_controller.dart';

class UserAnnouncements extends StatefulWidget {
  const UserAnnouncements({super.key});

  @override
  State<UserAnnouncements> createState() => _UserAnnouncementsState();
}

class _UserAnnouncementsState extends State<UserAnnouncements> {
  final UserAnnouncementsController _controller = UserAnnouncementsController();
  String selectedBarangay = '';
  String _searchQuery = '';
  Future<List<Map<String, dynamic>>>? _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _fetchBarangay();
  }

  Future<void> _fetchBarangay() async {
    final barangay = await _controller.getCurrentUserBarangay();
    setState(() {
      selectedBarangay = barangay;
      // Update the future when barangay changes
      if (selectedBarangay.isNotEmpty) {
        _announcementsFuture = _controller.fetchAllAnnouncements(selectedBarangay);
      }
    });
  }

  Future<void> _refreshAnnouncements() async {
    if (selectedBarangay.isNotEmpty) {
      setState(() {
        _announcementsFuture = _controller.fetchAllAnnouncements(selectedBarangay);
      });
    }
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
                onNotificationTap: () {
                  _controller.navigateToNotifications(context);
                },
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase();
                  });
                },
                onSearchSubmitted: (query) {
                  _controller.navigateToSearchResults(context, query, selectedBarangay, relWidth, relHeight);
                },
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
                              
                              // Filter announcements based on search query
                              final filteredAnnouncements = _controller.filterAnnouncements(announcements, _searchQuery);
                              
                              if (filteredAnnouncements.isEmpty && _searchQuery.isNotEmpty) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: relHeight(50)),
                                      Icon(
                                        Icons.search_off,
                                        size: relWidth(80),
                                        color: const Color(0x88888888),
                                      ),
                                      SizedBox(height: relHeight(20)),
                                      Container(
                                        width: relWidth(249),
                                        height: relHeight(26),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'No announcements found',
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
                              
                              return RefreshIndicator(
                                onRefresh: _refreshAnnouncements,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(top: relHeight(10), right: relWidth(20)),
                                  itemCount: filteredAnnouncements.length,
                                  itemBuilder: (context, index) {
                                    final data = filteredAnnouncements[index];
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
        onStoreTap: () => _controller.navigateToHome(context),
        onAnnouncementTap: () => _controller.navigateToAnnouncements(context),
        onSellTap: () => _controller.navigateToSell(context),
        onProfileTap: () => _controller.navigateToProfile(context),
        activeTab: 'announcements',
      ),
    );
  }
}


