import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../../admin/screens/admin_main_screen/admin_children_screen/child_details_screen/daily_notes_screen/note_model.dart';

class NotesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NotesRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<Note>> loadNotes(String childId) async {
    final snapshot =
        await _firestore.collection("DailyNotes").doc(childId).get();

    if (snapshot.exists && snapshot.data()?['notes'] != null) {
      final notesData =
          List<Map<String, dynamic>>.from(snapshot.data()!['notes']);
      return notesData.map((note) => Note.fromMap(note)).toList();
    }
    return [];
  }

  Future<void> saveNotes(String childId, List<Note> notes, bool isOthers,
      String? otherDoctorId) async {
    try {
      final batch = _firestore.batch();
      final notesData = notes.map((note) => note.toMap()).toList();

      // Save to DailyNotes collection
      batch.set(
        _firestore.collection("DailyNotes").doc(childId),
        {"notes": notesData},
      );

      // Get the appropriate user ID
      String? userId;
      if (isOthers && otherDoctorId != null) {
        final doctorSnap =
            await _firestore.collection("Doctors").doc(otherDoctorId).get();
        userId = doctorSnap["Doctor_id"];
      } else {
        userId = _auth.currentUser?.uid;
      }

      // Save to user's children collection and main Children collection
      if (userId != null) {
        batch.update(
          _firestore
              .collection("users")
              .doc(userId)
              .collection("children")
              .doc(childId),
          {"dailyNotes": notesData},
        );

        batch.update(
          _firestore.collection("Children").doc(childId),
          {"dailyNotes": notesData},
        );
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to save notes: $e');
    }
  }
}
