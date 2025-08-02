import 'package:cloud_firestore/cloud_firestore.dart';

class PostedAnnouncementModel {
  final String text;
  final String username;
  final String selectedBarangay;
  final String announcementId;
  final Timestamp? timestamp;
  final bool isExpanded;
  final bool isOverflowing;

  const PostedAnnouncementModel({
    required this.text,
    required this.username,
    required this.selectedBarangay,
    required this.announcementId,
    this.timestamp,
    this.isExpanded = false,
    this.isOverflowing = false,
  });

  PostedAnnouncementModel copyWith({
    String? text,
    String? username,
    String? selectedBarangay,
    String? announcementId,
    Timestamp? timestamp,
    bool? isExpanded,
    bool? isOverflowing,
  }) {
    return PostedAnnouncementModel(
      text: text ?? this.text,
      username: username ?? this.username,
      selectedBarangay: selectedBarangay ?? this.selectedBarangay,
      announcementId: announcementId ?? this.announcementId,
      timestamp: timestamp ?? this.timestamp,
      isExpanded: isExpanded ?? this.isExpanded,
      isOverflowing: isOverflowing ?? this.isOverflowing,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'username': username,
      'selectedBarangay': selectedBarangay,
      'announcementId': announcementId,
      'timestamp': timestamp,
      'isExpanded': isExpanded,
      'isOverflowing': isOverflowing,
    };
  }

  factory PostedAnnouncementModel.fromMap(Map<String, dynamic> map) {
    return PostedAnnouncementModel(
      text: map['text'] ?? '',
      username: map['username'] ?? '',
      selectedBarangay: map['selectedBarangay'] ?? '',
      announcementId: map['announcementId'] ?? '',
      timestamp: map['timestamp'],
      isExpanded: map['isExpanded'] ?? false,
      isOverflowing: map['isOverflowing'] ?? false,
    );
  }

  @override
  String toString() {
    return 'PostedAnnouncementModel(text: $text, username: $username, selectedBarangay: $selectedBarangay, announcementId: $announcementId, timestamp: $timestamp, isExpanded: $isExpanded, isOverflowing: $isOverflowing)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostedAnnouncementModel &&
        other.text == text &&
        other.username == username &&
        other.selectedBarangay == selectedBarangay &&
        other.announcementId == announcementId &&
        other.timestamp == timestamp &&
        other.isExpanded == isExpanded &&
        other.isOverflowing == isOverflowing;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        username.hashCode ^
        selectedBarangay.hashCode ^
        announcementId.hashCode ^
        timestamp.hashCode ^
        isExpanded.hashCode ^
        isOverflowing.hashCode;
  }
}
