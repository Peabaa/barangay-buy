import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This widget is a simplified version of PostedAnnouncement without delete button
class UserPostedAnnouncement extends StatelessWidget {
  final String text;
  final String username;
  final Timestamp? timestamp;
  final double Function(double) relWidth;
  final double Function(double) relHeight;
  final bool isAdmin;

  const UserPostedAnnouncement({
    super.key,
    required this.text,
    required this.username,
    required this.timestamp,
    required this.relWidth,
    required this.relHeight,
    this.isAdmin = false,
  });

  String _getFormattedTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateUtc = timestamp.toDate();
      final date = dateUtc.toLocal();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final month = months[date.month - 1];
      int hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final ampm = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return '$month ${date.day}, ${date.year}, $hour:$minute $ampm';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: relWidth(300),
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
          // Username and timestamp
          Padding(
            padding: EdgeInsets.only(
              top: relHeight(16),
              left: relWidth(10),
              right: relWidth(7),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: relHeight(14),
                  backgroundImage: AssetImage('assets/images/UserCircle.png'),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: relWidth(3)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            color: const Color(0xFF611A04),
                            fontFamily: 'Roboto',
                            fontSize: relWidth(15),
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (isAdmin) ...[
                          SizedBox(width: relWidth(6)),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: relWidth(6),
                              vertical: relHeight(2),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5B29),
                              borderRadius: BorderRadius.circular(relWidth(8)),
                            ),
                            child: Text(
                              'ADMIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: relWidth(8),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: relHeight(2)),
                    Text(
                      _getFormattedTimestamp(timestamp),
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
              ],
            ),
          ),
          SizedBox(height: relHeight(9)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: relWidth(14)),
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFF611A04),
                fontFamily: 'Roboto',
                fontSize: relWidth(13),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                height: 1.17176,
                letterSpacing: 0.22,
              ),
            ),
          ),
          SizedBox(height: relHeight(12)),
        ],
      ),
    );
  }
}