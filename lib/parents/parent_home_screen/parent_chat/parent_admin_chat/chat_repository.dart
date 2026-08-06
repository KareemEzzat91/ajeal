import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_message.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Initialize chat document
  Future<void> initializeChatDocument(
      String chatId, String doctorId, String parentId) async {
    await _firestore.collection('Chats').doc(chatId).set({
      'doctor_id': doctorId,
      'parent_id': parentId,
      'participants': [doctorId, parentId],
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Get messages stream
  Stream<List<ChatMessage>> getMessagesStream(String chatId) {
    return _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('Messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  // Get user online status stream
  Stream<DocumentSnapshot> getUserStatusStream(String userId) {
    return _firestore.collection('UserStatus').doc(userId).snapshots();
  }

  // Send a message
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    await _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('Messages')
        .add(message.toMap());

    await _firestore.collection('Chats').doc(chatId).update({
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // Update typing status
  Future<void> updateTypingStatus(
      String chatId, String role, bool isTyping) async {
    await _firestore.collection('Chats').doc(chatId).update({
      '${role}_typing': isTyping,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // Clear chat messages
  Future<void> clearChat(String chatId) async {
    final batch = _firestore.batch();
    final messages = await _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('Messages')
        .get();

    for (var message in messages.docs) {
      batch.delete(message.reference);
    }

    await batch.commit();
  }

  // Submit a report
  Future<void> submitReport(String chatId, String reporterId,
      String reporterRole, String reportText) async {
    await _firestore.collection('Reports').add({
      'chat_id': chatId,
      'reporter_id': reporterId,
      'reporter_role': reporterRole,
      'report_text': reportText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get doctor information
  Future<DocumentSnapshot> getDoctorInfo(String doctorId) {
    return _firestore.collection("Doctors").doc(doctorId).get();
  }
}
