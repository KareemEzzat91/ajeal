import 'package:ajeal/core/constants/firestore_collections.dart';
import 'package:ajeal/core/models/doctor_model/doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for doctor/admin user profile Firestore operations.
class DoctorRepository {
  DoctorRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static Map<String, dynamic> _defaultData() => {
        'Doctor_Name': '',
        'Doctor_id': '',
        'Doctor_phone': '',
        'lastChildId': 0,
        'lastChildName': '',
        'lastSessionWith': '',
        'taskAddedFor': '',
        'lastChattedWith': '',
      };

  /// Fetches the [Doctor] profile for the given [userId].
  Future<Doctor?> getDoctorInfo(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return Doctor.fromJson(snapshot.data() ?? _defaultData());
      }
      return Doctor.fromJson(_defaultData());
    } catch (_) {
      return Doctor.fromJson(_defaultData());
    }
  }

  /// Returns just the raw data map (useful when needing multiple fields at once).
  Future<Map<String, dynamic>> getDoctorData(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();
      return doc.data() ?? _defaultData();
    } catch (_) {
      return _defaultData();
    }
  }

  /// Updates a single [key]-[value] pair on the doctor document.
  Future<void> updateDoctorField(
      String userId, String key, String value) async {
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .update({key: value});
  }
}
