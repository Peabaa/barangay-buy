import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_header_footer.dart';
import 'posted_announcement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_signup.dart';

class AdminAnnouncements extends StatefulWidget {
  final String selectedBarangay;

  const AdminAnnouncements({super.key, this.selectedBarangay = 'Banilad'});

  @override
  _AdminAnnouncementsState createState() => _AdminAnnouncementsState();
}

class _AdminAnnouncementsState extends State<AdminAnnouncements> {
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
              child: AdminHeader(
                relWidth: relWidth,
                relHeight: relHeight,
                selectedBarangay: widget.selectedBarangay
              ),
            ),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: relHeight(34),
                left: relWidth(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Announcements header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Padding(
                        padding: EdgeInsets.only(right: relWidth(50)),
                        child: GestureDetector(
                          onTap: () {
                            final dialogController = TextEditingController();
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.symmetric(horizontal: 24),
                                child: Container(
                                  width: relWidth(312),
                                  height: relHeight(257),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F2F2),
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                      color: const Color.fromRGBO(0, 0, 0, 0.22),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: relHeight(15)),
                                      Container(
                                        width: relWidth(215),
                                        height: relHeight(17),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Create Announcement',
                                          style: TextStyle(
                                            color: const Color(0xFF611A04),
                                            fontFamily: 'Roboto',
                                            fontSize: relWidth(16),
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.32,
                                            height: 1.17182,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: relHeight(9)),
                                      Container(
                                        width: relWidth(312),
                                        height: 0,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: const Color.fromRGBO(0, 0, 0, 0.22),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: relHeight(15)),
                                      Container(
                                        width: relWidth(275),
                                        height: relHeight(145),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                            color: const Color(0xFF611A04),
                                            width: 1,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(relWidth(12)),
                                          child: TextField(
                                            controller: dialogController,
                                            maxLines: null,
                                            expands: true,
                                            decoration: const InputDecoration(
                                              hintText: 'Post your announcement here...',
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: relWidth(14),
                                              color: const Color(0xFF611A04),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: relHeight(15)),
                                      SizedBox(
                                        width: relWidth(275),
                                        height: relHeight(28),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final text = dialogController.text.trim();
                                            if (text.isNotEmpty) {
                                              final user = FirebaseAuth.instance.currentUser;
                                              final userDoc = await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user!.uid)
                                                  .get();
                                              final username = userDoc.data()?['username'] ?? user.email ?? 'Unknown';

                                              await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user!.uid)
                                                .collection('announcements')
                                                .add({
                                                  'text': text,
                                                  'barangay': widget.selectedBarangay,
                                                  'timestamp': FieldValue.serverTimestamp(),
                                                  'adminEmail': user.email,
                                                  'username': username,
                                                });

                                              Navigator.of(context).pop();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF611A04),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                            padding: EdgeInsets.zero,
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            'Post',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: relWidth(14),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: relHeight(10)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/addanounce.png',
                            width: relWidth(24),
                            height: relWidth(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('announcements')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
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
                                    relHeight(26.75),
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
                                  height: relHeight(30),
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
                          padding: EdgeInsets.only(top: relHeight(20),right: relWidth(20)),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            return Center(
                              child: PostedAnnouncement(
                                announcementId: docs[index].id,
                                text: data['text'] ?? '',
                                username: data['username'] ?? 'Unknown',
                                selectedBarangay: widget.selectedBarangay,
                                timestamp: data['timestamp'],
                              ),
                            );
                          },
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
      bottomNavigationBar: AdminFooter(
        relWidth: relWidth,
        relHeight: relHeight,
      ),
    );
  }
}