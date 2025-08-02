import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/posted_announcement_model.dart';
import './announcement_controller.dart';

class PostedAnnouncementController {
  // Static methods for handling posted announcement operations

  /// Format timestamp for display
  static String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    try {
      // Convert UTC to local time
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

  /// Check if text is overflowing for given constraints
  static bool checkTextOverflow(String text, double maxWidth, TextStyle style) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      maxLines: 5,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: maxWidth);
    return tp.didExceedMaxLines;
  }

  /// Toggle expansion state
  static PostedAnnouncementModel toggleExpansion(PostedAnnouncementModel model) {
    return model.copyWith(isExpanded: !model.isExpanded);
  }

  /// Update overflow status
  static PostedAnnouncementModel updateOverflowStatus(
    PostedAnnouncementModel model, 
    bool isOverflowing
  ) {
    return model.copyWith(isOverflowing: isOverflowing);
  }

  /// Delete announcement using existing AnnouncementController
  static Future<bool> deleteAnnouncement(String announcementId) async {
    try {
      await AnnouncementController.deleteAnnouncement(announcementId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Create announcement using existing AnnouncementController
  static Future<bool> createAnnouncement({
    required String text,
    required String barangay,
  }) async {
    try {
      await AnnouncementController.createAnnouncement(
        text: text,
        barangay: barangay,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get text style for announcement content
  static TextStyle getAnnouncementTextStyle(double fontSize) {
    return TextStyle(
      color: const Color(0xFF611A04),
      fontFamily: 'Roboto',
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      height: 1.17176,
      letterSpacing: 0.22,
    );
  }

  /// Get username text style
  static TextStyle getUsernameTextStyle(double fontSize) {
    return TextStyle(
      color: const Color(0xFF611A04),
      fontFamily: 'Roboto',
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      letterSpacing: 0.5,
    );
  }

  /// Get timestamp text style
  static TextStyle getTimestampTextStyle(double fontSize) {
    return TextStyle(
      color: const Color.fromRGBO(0, 0, 0, 0.31),
      fontFamily: 'Roboto',
      fontSize: fontSize,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
      height: 1.17164,
      letterSpacing: 0.2,
    );
  }

  /// Get dialog title text style
  static TextStyle getDialogTitleTextStyle(double fontSize) {
    return TextStyle(
      color: const Color(0xFF611A04),
      fontFamily: 'Roboto',
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      height: 1.17182,
      letterSpacing: 0.32,
    );
  }

  /// Get dialog message text style
  static TextStyle getDialogMessageTextStyle(double fontSize) {
    return TextStyle(
      color: const Color(0xFF611A04),
      fontFamily: 'Roboto',
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      height: 1.17182,
      letterSpacing: 0.4,
    );
  }

  /// Get delete button text style
  static TextStyle getDeleteButtonTextStyle(double fontSize) {
    return TextStyle(
      color: Colors.white,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
    );
  }

  /// Validate announcement text
  static bool isValidAnnouncementText(String text) {
    return text.trim().isNotEmpty;
  }

  /// Calculate container constraints based on expansion state
  static BoxConstraints getContainerConstraints(
    bool isExpanded,
    double minHeight,
    double maxHeight,
  ) {
    return BoxConstraints(
      minHeight: minHeight,
      maxHeight: isExpanded ? double.infinity : maxHeight,
    );
  }
}
