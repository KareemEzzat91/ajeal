import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ajeal/core/constants/firestore_collections.dart';
import 'package:ajeal/core/models/note_model/note_model.dart';
import 'package:ajeal/features/admin/children/data/doctor_repository.dart';

/// Repository for daily notes Firestore operations.
class NotesRepository {
  NotesRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    DoctorRepository? doctorRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _doctorRepo = doctorRepository ?? DoctorRepository();

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final DoctorRepository _doctorRepo;

  Future<List<Note>> loadNotes(String childId) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.dailyNotes)
        .doc(childId)
        .get();

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
        _firestore.collection(FirestoreCollections.dailyNotes).doc(childId),
        {"notes": notesData},
      );

      // Resolve the appropriate user ID
      String? userId;
      if (isOthers && otherDoctorId != null) {
        // Delegate uid resolution to the repository — no raw Firestore in here.
        userId = await _doctorRepo.resolveDoctorUid(otherDoctorId);
      } else {
        userId = _auth.currentUser?.uid;
      }

      // Save to user's children collection and main Children collection
      if (userId != null) {
        batch.update(
          _firestore
              .collection(FirestoreCollections.users)
              .doc(userId)
              .collection(FirestoreCollections.userChildren)
              .doc(childId),
          {"dailyNotes": notesData},
        );

        batch.update(
          _firestore.collection(FirestoreCollections.children).doc(childId),
          {"dailyNotes": notesData},
        );
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to save notes: $e');
    }
  }
}
