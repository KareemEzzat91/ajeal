import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/models/chat_message/chat_message.dart';

/// Repository for chat Firestore operations.
/// Moved from the presentation layer into the data layer.
class ChatRepository {
  ChatRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  /// Initializes the chat document if it doesn't exist.
  Future<void> initializeChatDocument(
      String chatId, String doctorId, String parentId) async {
    await _firestore.collection(FirestoreCollections.chats).doc(chatId).set({
      'doctor_id': doctorId,
      'parent_id': parentId,
      'participants': [doctorId, parentId],
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Returns a stream of messages for a chat.
  Stream<List<ChatMessage>> getMessagesStream(String chatId) {
    return _firestore
        .collection(FirestoreCollections.chats)
        .doc(chatId)
        .collection('Messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  /// Returns a stream for a user's online status.
  Stream<DocumentSnapshot> getUserStatusStream(String userId) {
    return _firestore
        .collection(FirestoreCollections.userStatus)
        .doc(userId)
        .snapshots();
  }

  /// Sends a [message] to a chat.
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    await _firestore
        .collection(FirestoreCollections.chats)
        .doc(chatId)
        .collection('Messages')
        .add(message.toMap());

    await _firestore
        .collection(FirestoreCollections.chats)
        .doc(chatId)
        .update({'updated_at': FieldValue.serverTimestamp()});
  }

  /// Updates typing status for a user.
  Future<void> updateTypingStatus(
      String chatId, String role, bool isTyping) async {
    await _firestore
        .collection(FirestoreCollections.chats)
        .doc(chatId)
        .update({
      '${role}_typing': isTyping,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  /// Clears all messages in a chat.
  Future<void> clearChat(String chatId) async {
    final batch = _firestore.batch();
    final messages = await _firestore
        .collection(FirestoreCollections.chats)
        .doc(chatId)
        .collection('Messages')
        .get();

    for (var message in messages.docs) {
      batch.delete(message.reference);
    }

    await batch.commit();
  }

  /// Submits a report for a chat.
  Future<void> submitReport(String chatId, String reporterId,
      String reporterRole, String reportText) async {
    await _firestore.collection(FirestoreCollections.reports).add({
      'chat_id': chatId,
      'reporter_id': reporterId,
      'reporter_role': reporterRole,
      'report_text': reportText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Gets doctor information by [doctorId].
  Future<DocumentSnapshot> getDoctorInfo(String doctorId) {
    return _firestore.collection(FirestoreCollections.users).doc(doctorId).get();
  }
}
