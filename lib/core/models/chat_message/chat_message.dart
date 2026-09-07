import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String senderRole;
  final String text;
  final Timestamp? timestamp;
  final bool read;
  final String type;

  ChatMessage({
    required this.senderId,
    required this.senderRole,
    required this.text,
    this.timestamp,
    this.read = false,
    this.type = 'text',
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['sender_id'] ?? '',
      senderRole: map['sender_role'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] as Timestamp?,
      read: map['read'] ?? false,
      type: map['type'] ?? 'text',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'sender_role': senderRole,
      'text': text,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
      'read': read,
      'type': type,
    };
  }
}
