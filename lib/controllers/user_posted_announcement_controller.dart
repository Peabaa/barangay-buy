import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_posted_announcement_model.dart';

class UserPostedAnnouncementController {
  final UserPostedAnnouncementModel _model = UserPostedAnnouncementModel();

  // Get formatted timestamp
  String getFormattedTimestamp(Timestamp? timestamp) {
    return _model.getFormattedTimestamp(timestamp);
  }

  // Get admin badge colors
  Color getAdminBadgeBackgroundColor() {
    return const Color(0xFFFF5B29);
  }

  Color getAdminBadgeTextColor() {
    return Colors.white;
  }

  // Get container styling colors
  Color getContainerBackgroundColor() {
    return const Color(0xFFF3F2F2);
  }

  Color getContainerBorderColor() {
    return const Color.fromRGBO(0, 0, 0, 0.22);
  }

  // Get text styling colors
  Color getUsernameTextColor() {
    return const Color(0xFF611A04);
  }

  Color getAnnouncementTextColor() {
    return const Color(0xFF611A04);
  }

  Color getTimestampTextColor() {
    return const Color.fromRGBO(0, 0, 0, 0.31);
  }

  // Get user avatar path
  String getUserAvatarPath() {
    return _model.getDefaultUserAvatarPath();
  }

  // Validate announcement data
  bool isValidAnnouncement(String text, String username) {
    return _model.isValidAnnouncement(text, username);
  }

  // Get container dimensions and styling
  Map<String, dynamic> getContainerStyling(
    double Function(double) relWidth,
    double Function(double) relHeight,
  ) {
    return {
      'width': relWidth(300),
      'marginVertical': relHeight(8),
      'borderRadius': relWidth(3),
      'borderWidth': 1.0,
      'paddingTop': relHeight(16),
      'paddingLeft': relWidth(10),
      'paddingRight': relWidth(7),
      'paddingHorizontal': relWidth(14),
      'paddingBottom': relHeight(12),
      'spacingAfterHeader': relHeight(9),
      'spacingAfterTimestamp': relHeight(2),
      'avatarRadius': relHeight(14),
      'spacingAfterAvatar': relWidth(3),
      'adminBadgeSpacing': relWidth(6),
    };
  }

  // Get text styling
  Map<String, dynamic> getUsernameTextStyle(double Function(double) relWidth) {
    return {
      'fontSize': relWidth(15),
      'fontWeight': FontWeight.w400,
      'fontStyle': FontStyle.italic,
      'letterSpacing': 0.5,
    };
  }

  Map<String, dynamic> getTimestampTextStyle(double Function(double) relWidth) {
    return {
      'fontSize': relWidth(10),
      'fontStyle': FontStyle.italic,
      'fontWeight': FontWeight.w400,
      'height': 1.17164,
      'letterSpacing': 0.2,
    };
  }

  Map<String, dynamic> getAnnouncementTextStyle(double Function(double) relWidth) {
    return {
      'fontSize': relWidth(13),
      'fontWeight': FontWeight.w400,
      'fontStyle': FontStyle.normal,
      'height': 1.17176,
      'letterSpacing': 0.22,
    };
  }

  Map<String, dynamic> getAdminBadgeTextStyle(double Function(double) relWidth) {
    return {
      'fontSize': relWidth(8),
      'fontWeight': FontWeight.w700,
      'letterSpacing': 0.3,
    };
  }

  // Get admin badge styling
  Map<String, dynamic> getAdminBadgeStyling(
    double Function(double) relWidth,
    double Function(double) relHeight,
  ) {
    return {
      'paddingHorizontal': relWidth(6),
      'paddingVertical': relHeight(2),
      'borderRadius': relWidth(8),
    };
  }
}