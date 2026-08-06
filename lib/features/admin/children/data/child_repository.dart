import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/models/child_model/child_model.dart';

/// Repository responsible for all Child-related Firestore operations.
/// Cubits must NOT access Firestore directly – use this class instead.
class ChildRepository {
  ChildRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Fetches all children belonging to [userId].
  Future<List<Map<String, Child>>> fetchChildren(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .collection(FirestoreCollections.userChildren)
          .get();

      return snapshot.docs
          .map((doc) => {doc.id: Child.fromJson(doc.data())})
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetches children assigned to [userId] from other doctors,
  /// syncing them from the global Children collection.
  Future<List<Map<String, Child>>> fetchOthersChildren(String userId) async {
    try {
      final othersSnapshot = await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .collection(FirestoreCollections.userOthersChildren)
          .get();

      if (othersSnapshot.docs.isEmpty) return [];

      final parentPhones = othersSnapshot.docs.map((d) => d.id).toList();

      // Firestore whereIn is limited to 10 items per query
      final futures = <Future<QuerySnapshot>>[];
      for (int i = 0; i < parentPhones.length; i += 10) {
        final chunk = parentPhones.sublist(
            i, (i + 10 < parentPhones.length) ? i + 10 : parentPhones.length);
        futures.add(_firestore
            .collection(FirestoreCollections.children)
            .where(FieldPath.documentId, whereIn: chunk)
            .get());
      }

      final snapshots = await Future.wait(futures);
      final mainMap = <String, Child>{};
      for (final snapshot in snapshots) {
        for (final doc in snapshot.docs) {
          mainMap[doc.id] = Child.fromJson(doc.data() as Map<String, dynamic>);
        }
      }

      final result = <Map<String, Child>>[];
      final batch = _firestore.batch();

      for (final childDoc in othersSnapshot.docs) {
        final phone = childDoc.id;
        if (mainMap.containsKey(phone)) {
          final updated = mainMap[phone]!;
          result.add({phone: updated});
          batch.set(
            _firestore
                .collection(FirestoreCollections.users)
                .doc(userId)
                .collection(FirestoreCollections.userOthersChildren)
                .doc(phone),
            updated.toMap(),
          );
        } else {
          result.add({phone: Child.fromJson(childDoc.data())});
        }
      }

      await batch.commit();
      return result;
    } catch (_) {
      return [];
    }
  }

  /// Saves a new [child] under [userId]/children and the global Children collection.
  Future<void> saveChild(String userId, String parentPhone, Child child) async {
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .collection(FirestoreCollections.userChildren)
        .doc(parentPhone)
        .set(child.toMap());

    await _firestore
        .collection(FirestoreCollections.children)
        .doc(parentPhone)
        .set(child.toMap());

    await _firestore
        .collection(FirestoreCollections.dailyNotes)
        .doc(parentPhone)
        .set({'notes': []});
  }

  /// Updates the lastChildId and lastChildName metadata on the user document.
  Future<void> updateLastChildMeta(
      String userId, int lastId, String lastName) async {
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .update({'lastChildId': lastId, 'lastChildName': lastName});
  }

  /// Fetches a single child by [parentPhone] from the global Children collection.
  Future<Child?> fetchChildByPhone(String parentPhone) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.children)
          .doc(parentPhone)
          .get();
      if (doc.exists && doc.data() != null) {
        return Child.fromJson(doc.data()!);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Deletes a child from the doctor's list.
  Future<void> deleteChild(
      String userId, String parentPhone, bool isOthers) async {
    final collection = isOthers
        ? FirestoreCollections.userOthersChildren
        : FirestoreCollections.userChildren;
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .collection(collection)
        .doc(parentPhone)
        .delete();
  }

  /// Updates session details for a child.
  Future<void> updateSession({
    required String doctorId,
    required String childId,
    required int sessionName,
    required Map<String, dynamic> sessionData,
    required bool isCompleted,
    required int completedSessions,
  }) async {
    final userRef = _firestore
        .collection(FirestoreCollections.users)
        .doc(doctorId)
        .collection(FirestoreCollections.userChildren)
        .doc(childId);

    final userSnapshot = await userRef.get();
    if (!userSnapshot.exists) throw Exception('Child data not found');

    final currentScheduleSesoins = List<Map<String, dynamic>>.from(
        userSnapshot.data()!['scheduleSessions'] ??
            userSnapshot.data()!['scheduleSesoins'] ??
            []);

    if (sessionName - 1 < currentScheduleSesoins.length) {
      currentScheduleSesoins[sessionName - 1] = sessionData;
    } else {
      currentScheduleSesoins.add(sessionData);
    }

    final cmp = isCompleted ? completedSessions : completedSessions + 1;

    await userRef.update({
      'scheduleSessions': currentScheduleSesoins,
      'scheduleSesoins': currentScheduleSesoins,
      'completedSessions': cmp
    });

    await _firestore
        .collection(FirestoreCollections.children)
        .doc(childId)
        .update({
      'scheduleSessions': currentScheduleSesoins,
      'scheduleSesoins': currentScheduleSesoins,
      'completedSessions': cmp
    });
  }
}
