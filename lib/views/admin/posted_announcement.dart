import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/posted_announcement_controller.dart';
import '../../models/posted_announcement_model.dart';

class PostedAnnouncement extends StatefulWidget {
  final String text;
  final String username;
  final String selectedBarangay;
  final String announcementId;
  final Timestamp? timestamp;
  const PostedAnnouncement({
    super.key,
    required this.text,
    required this.username,
    required this.selectedBarangay,
    required this.announcementId,
    required this.timestamp,
  });

  @override
  State<PostedAnnouncement> createState() => _PostedAnnouncementState();
}

class _PostedAnnouncementState extends State<PostedAnnouncement> {
  late PostedAnnouncementModel _model;

  @override
  void initState() {
    super.initState();
    _model = PostedAnnouncementModel(
      text: widget.text,
      username: widget.username,
      selectedBarangay: widget.selectedBarangay,
      announcementId: widget.announcementId,
      timestamp: widget.timestamp,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    final textStyle = PostedAnnouncementController.getAnnouncementTextStyle(relWidth(13));

    final isOverflowing = PostedAnnouncementController.checkTextOverflow(
      _model.text,
      relWidth(300) - relWidth(28), 
      textStyle,
    );

    // Update model with overflow status if changed
    if (isOverflowing != _model.isOverflowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _model = PostedAnnouncementController.updateOverflowStatus(_model, isOverflowing);
        });
      });
    }

    return Container(
      width: relWidth(300), // Use a fixed width relative to screen size
      constraints: PostedAnnouncementController.getContainerConstraints(
        _model.isExpanded,
        relHeight(173),
        relHeight(173),
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
            height: relHeight(38),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: PostedAnnouncementController.getUsernameTextStyle(relWidth(15)),
                    ),
                    SizedBox(height: relHeight(2)),
                    Container(
                      width: relWidth(130),
                      height: relHeight(12),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        PostedAnnouncementController.formatTimestamp(widget.timestamp),
                        style: PostedAnnouncementController.getTimestampTextStyle(relWidth(10)),
                      ),
                    ),
                  ],
                ),
                Spacer(),
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
                                height: relHeight(19),
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                  top: relHeight(6), 
                                  bottom: relHeight(8), 
                                ),
                                child: Text(
                                  'Delete Announcement',
                                  textAlign: TextAlign.center,
                                  style: PostedAnnouncementController.getDialogTitleTextStyle(relWidth(18)),
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
                              SizedBox(height: relHeight(16)), 
                              Container(
                                width: relWidth(232),
                                height: relHeight(81),
                                alignment: Alignment.center,
                                child: Text(
                                  'Do you want to delete this announcement?',
                                  textAlign: TextAlign.center,
                                  style: PostedAnnouncementController.getDialogMessageTextStyle(relWidth(20)),
                                ),
                              ),
                              SizedBox(height: relHeight(15)),
                              GestureDetector(
                                onTap: () async {
                                  // Delete using the controller
                                  try {
                                    bool success = await PostedAnnouncementController.deleteAnnouncement(widget.announcementId);
                                    Navigator.of(context).pop();
                                    if (success) {
                                      setState(() {}); // Refresh UI
                                    }
                                  } catch (e) {
                                    // Handle error if needed
                                  }
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
                                    style: PostedAnnouncementController.getDeleteButtonTextStyle(relWidth(16)),
                                  ),
                                ),
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
          SizedBox(height: relHeight(9)), 
          Padding(
            padding: EdgeInsets.symmetric(horizontal: relWidth(14)),
            child: Text(
              _model.text,
              maxLines: _model.isExpanded ? null : 5,
              overflow: _model.isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),
          if (_model.isOverflowing || _model.isExpanded)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    _model = PostedAnnouncementController.toggleExpansion(_model);
                  }),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: relHeight(8),
                      top: relHeight(4),
                    ),
                    child: Image.asset(
                      _model.isExpanded
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

  Future<void> postAnnouncement(String text) async {
    await PostedAnnouncementController.createAnnouncement(
      text: text,
      barangay: widget.selectedBarangay,
    );
  }
}
