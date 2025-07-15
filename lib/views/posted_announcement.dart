import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostedAnnouncement extends StatefulWidget {
  final String text;
  final String username;
  final String selectedBarangay;
  final String announcementId;
  const PostedAnnouncement({
    super.key,
    required this.text,
    required this.username,
    required this.selectedBarangay,
    required this.announcementId, // <-- add this
  });

  @override
  State<PostedAnnouncement> createState() => _PostedAnnouncementState();
}

class _PostedAnnouncementState extends State<PostedAnnouncement> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    final textStyle = TextStyle(
      color: const Color(0xFF611A04),
      fontFamily: 'Roboto',
      fontSize: relWidth(13),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      height: 1.17176,
      letterSpacing: 0.22,
    );

    final isOverflowing = _isOverflowing(
      widget.text,
      relWidth(300) - relWidth(28), // container width minus padding
      textStyle,
    );

    return Container(
      width: relWidth(300), // Use a fixed width relative to screen size
      constraints: BoxConstraints(
        minHeight: relHeight(173),
        maxHeight: expanded ? double.infinity : relHeight(173),
      ),
      clipBehavior: Clip.hardEdge, // Add this to prevent overflow warning
      margin: EdgeInsets.symmetric(vertical: relHeight(8)),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2F2),
        borderRadius: BorderRadius.circular(relWidth(3)),
        border: Border.all(
          color: const Color.fromRGBO(0, 0, 0, 0.22),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username field with user image
          Container(
            height: relHeight(28),
            margin: EdgeInsets.only(
              top: relHeight(16),
              left: relWidth(10),
              right: relWidth(7),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User image and username
                CircleAvatar(
                  radius: relHeight(14),
                  backgroundImage:
                      AssetImage('assets/images/UserCircle.png'),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: relWidth(3)),
                Text(
                  widget.username,
                  style: TextStyle(
                    color: const Color(0xFF611A04),
                    fontFamily: 'Roboto',
                    fontSize: relWidth(15),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: relWidth(59)), // <-- Adjust this value for your desired gap
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Center(
                        child: Container(
                          width: relWidth(312),
                          height: relHeight(230),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F2F2),
                            borderRadius: BorderRadius.circular(relWidth(3)),
                            border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 0.22),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // "Delete Announcement" title
                              Container(
                                width: relWidth(215),
                                height: relHeight(17),
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                  top: relHeight(6), 
                                  bottom: relHeight(8), 
                                ),
                                child: Text(
                                  'Delete Announcement',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF611A04),
                                    fontFamily: 'Roboto',
                                    fontSize: relWidth(18),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    height: 1.17182,
                                    letterSpacing: 0.32,
                                  ),
                                ),
                              ),
                              // Divider line, 9px below the title
                              Container(
                                width: relWidth(312),
                                height: 0,
                                margin: EdgeInsets.only(top: relHeight(9)),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: const Color.fromRGBO(0, 0, 0, 0.22),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: relHeight(16)), // Optional: space between line and message
                              Container(
                                width: relWidth(232),
                                height: relHeight(81),
                                alignment: Alignment.center,
                                child: Text(
                                  'Do you want to delete this announcement?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF611A04),
                                    fontFamily: 'Roboto',
                                    fontSize: relWidth(20),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    height: 1.17182, // 117.182%
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: relHeight(15)),
                              Column(
                                children: [
                                  // Centered Delete button
                                  GestureDetector(
                                    onTap: () async {
                                      // Delete the announcement from Firestore
                                      await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth.instance.currentUser!.uid)
                                        .collection('announcements')
                                        .doc(widget.announcementId)
                                        .delete();
                                      Navigator.of(context).pop(); // Close the dialog
                                      // Optionally: show a snackbar or refresh the list
                                    },
                                    child: Container(
                                      width: relWidth(133),
                                      height: relHeight(28),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF611A04).withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(relWidth(3)),
                                        border: Border.all(
                                          color: const Color(0xFF611A04),
                                          width: 1,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700,
                                          fontSize: relWidth(16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/Trash.png',
                    width: relWidth(32),
                    height: relHeight(32),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: relHeight(9)), // 9px space between username and text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: relWidth(14)),
            child: Text(
              widget.text,
              maxLines: expanded ? null : 5,
              overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),
          if (isOverflowing || expanded)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => expanded = !expanded),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: relHeight(8),
                      top: relHeight(4),
                    ),
                    child: Image.asset(
                      expanded
                          ? 'assets/images/arrow-up.png'
                          : 'assets/images/arrow-down.png',
                      width: relWidth(24),
                      height: relWidth(24),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  bool _isOverflowing(String text, double maxWidth, TextStyle style) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      maxLines: 5,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: maxWidth);
    return tp.didExceedMaxLines;
  }

  Future<void> postAnnouncement(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final username = userDoc.data()?['username'] ?? user.email ?? 'Unknown';

    await FirebaseFirestore.instance.collection('announcements').add({
      'text': text,
      'barangay': widget.selectedBarangay,
      'timestamp': FieldValue.serverTimestamp(),
      'adminEmail': user.email,
      'username': username, 
    });
  }
}
