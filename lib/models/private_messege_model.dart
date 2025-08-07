import 'package:cloud_firestore/cloud_firestore.dart';

class PrivateMessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final Timestamp timestamp;
  final bool isSeen;  // changed to bool

  PrivateMessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.isSeen,
  });

  factory PrivateMessageModel.fromMap(Map<String, dynamic> map) {
    return PrivateMessageModel(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      isSeen: map['isSeen'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
      'isSeen': isSeen,
    };
  }
}