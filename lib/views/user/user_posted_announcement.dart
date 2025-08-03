import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/user_posted_announcement_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    final UserPostedAnnouncementController controller = UserPostedAnnouncementController();
    final containerStyling = controller.getContainerStyling(relWidth, relHeight);
    final usernameStyle = controller.getUsernameTextStyle(relWidth);
    final timestampStyle = controller.getTimestampTextStyle(relWidth);
    final announcementStyle = controller.getAnnouncementTextStyle(relWidth);
    final adminBadgeStyle = controller.getAdminBadgeTextStyle(relWidth);
    final adminBadgeStyling = controller.getAdminBadgeStyling(relWidth, relHeight);

    return Container(
      width: containerStyling['width'],
      margin: EdgeInsets.symmetric(vertical: containerStyling['marginVertical']),
      decoration: BoxDecoration(
        color: controller.getContainerBackgroundColor(),
        borderRadius: BorderRadius.circular(containerStyling['borderRadius']),
        border: Border.all(
          color: controller.getContainerBorderColor(),
          width: containerStyling['borderWidth'],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username and timestamp
          Padding(
            padding: EdgeInsets.only(
              top: containerStyling['paddingTop'],
              left: containerStyling['paddingLeft'],
              right: containerStyling['paddingRight'],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: containerStyling['avatarRadius'],
                  backgroundImage: AssetImage(controller.getUserAvatarPath()),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: containerStyling['spacingAfterAvatar']),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            color: controller.getUsernameTextColor(),
                            fontFamily: 'Roboto',
                            fontSize: usernameStyle['fontSize'],
                            fontWeight: usernameStyle['fontWeight'],
                            fontStyle: usernameStyle['fontStyle'],
                            letterSpacing: usernameStyle['letterSpacing'],
                          ),
                        ),
                        if (isAdmin) ...[
                          SizedBox(width: containerStyling['adminBadgeSpacing']),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: adminBadgeStyling['paddingHorizontal'],
                              vertical: adminBadgeStyling['paddingVertical'],
                            ),
                            decoration: BoxDecoration(
                              color: controller.getAdminBadgeBackgroundColor(),
                              borderRadius: BorderRadius.circular(adminBadgeStyling['borderRadius']),
                            ),
                            child: Text(
                              'ADMIN',
                              style: TextStyle(
                                color: controller.getAdminBadgeTextColor(),
                                fontFamily: 'Roboto',
                                fontSize: adminBadgeStyle['fontSize'],
                                fontWeight: adminBadgeStyle['fontWeight'],
                                letterSpacing: adminBadgeStyle['letterSpacing'],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: containerStyling['spacingAfterTimestamp']),
                    Text(
                      controller.getFormattedTimestamp(timestamp),
                      style: TextStyle(
                        color: controller.getTimestampTextColor(),
                        fontFamily: 'Roboto',
                        fontSize: timestampStyle['fontSize'],
                        fontStyle: timestampStyle['fontStyle'],
                        fontWeight: timestampStyle['fontWeight'],
                        height: timestampStyle['height'],
                        letterSpacing: timestampStyle['letterSpacing'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: containerStyling['spacingAfterHeader']),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: containerStyling['paddingHorizontal']),
            child: Text(
              text,
              style: TextStyle(
                color: controller.getAnnouncementTextColor(),
                fontFamily: 'Roboto',
                fontSize: announcementStyle['fontSize'],
                fontWeight: announcementStyle['fontWeight'],
                fontStyle: announcementStyle['fontStyle'],
                height: announcementStyle['height'],
                letterSpacing: announcementStyle['letterSpacing'],
              ),
            ),
          ),
          SizedBox(height: containerStyling['paddingBottom']),
        ],
      ),
    );
  }
}