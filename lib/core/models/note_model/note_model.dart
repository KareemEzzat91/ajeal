import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String text;
  final DateTime date;
  final String sender;

  Note({
    required this.id,
    required this.text,
    required this.date,
    required this.sender,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      sender: map['sender'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': Timestamp.fromDate(date),
      'sender': sender,
    };
  }
}
