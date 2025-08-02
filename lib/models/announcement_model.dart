import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  final String id;
  final String text;
  final String username;
  final String barangay;
  final String adminEmail;
  final Timestamp? timestamp;

  AnnouncementModel({
    required this.id,
    required this.text,
    required this.username,
    required this.barangay,
    required this.adminEmail,
    this.timestamp,
  });

  // Factory constructor to create from Firestore document
  factory AnnouncementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnnouncementModel(
      id: doc.id,
      text: data['text'] ?? '',
      username: data['username'] ?? 'Unknown',
      barangay: data['barangay'] ?? '',
      adminEmail: data['adminEmail'] ?? '',
      timestamp: data['timestamp'] as Timestamp?,
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'username': username,
      'barangay': barangay,
      'adminEmail': adminEmail,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  // Create a copy with updated fields
  AnnouncementModel copyWith({
    String? id,
    String? text,
    String? username,
    String? barangay,
    String? adminEmail,
    Timestamp? timestamp,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      text: text ?? this.text,
      username: username ?? this.username,
      barangay: barangay ?? this.barangay,
      adminEmail: adminEmail ?? this.adminEmail,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
