import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ajeal/core/constants/firestore_collections.dart';
import 'package:ajeal/core/constants/preference_keys.dart';

/// Repository for all Firebase Auth and session operations.
/// Extracted from SignCubit to keep cubits free of Firestore/Auth calls.
class AuthRepository {
  AuthRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // ─── Login ─────────────────────────────────────────────────────────────────

  /// Signs in with [email] and [password].
  /// Returns a map with doctorId, doctorName, doctorPhone on success.
  /// Throws descriptive [Exception] on any failure.
  Future<Map<String, String>> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = credential.user;
    if (user == null) throw Exception('Login failed');

    if (!user.emailVerified) {
      await user.sendEmailVerification();
      throw Exception('Please verify your account. Check your email.');
    }

    final snap = await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .get();

    if (!snap.exists) throw Exception('User data not found');

    final doctorId = snap['Doctor_id'] as String;
    final doctorName = snap['Doctor_Name'] as String;
    final doctorPhone = snap['Doctor_phone'] as String;

    // Keep Doctors lookup-doc in sync with actual uid.
    await _firestore
        .collection(FirestoreCollections.doctors)
        .doc(doctorId)
        .update({'Doctor_id': user.uid});

    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorPhone': doctorPhone,
    };
  }

  // ─── Sign Up ────────────────────────────────────────────────────────────────

  /// Creates a new doctor account.
  /// Returns a map with doctorId, doctorName, doctorPhone on success.
  /// Throws descriptive [Exception] on any failure.
  Future<Map<String, String>> signUp({
    required String email,
    required String password,
    required String name,
    required String mobile,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = credential.user;
    if (user == null) throw Exception('User creation failed');

    final doctorId = '${name.trim()}${mobile.trim()}';

    await user.sendEmailVerification();

    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .set({
      'Doctor_Name': name.trim(),
      'Doctor_id': doctorId,
      'Doctor_phone': mobile.trim(),
      'lastChildId': 0,
      'lastChattedWith': '',
      'lastChildName': '',
      'lastSessionWith': '',
      'taskAddedFor': '',
    });

    await _firestore
        .collection(FirestoreCollections.doctors)
        .doc(doctorId)
        .set({'Doctor_id': user.uid});

    return {
      'doctorId': doctorId,
      'doctorName': name.trim(),
      'doctorPhone': mobile.trim(),
    };
  }

  // ─── Session ────────────────────────────────────────────────────────────────

  /// Persists the admin session to SharedPreferences.
  Future<void> saveAdminSession(
      String doctorId, String doctorName, String doctorPhone) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(PreferenceKeys.adminLogin, true);
    await pref.setString(PreferenceKeys.adminDoctorId, doctorId);
    await pref.setString(PreferenceKeys.adminDoctorName, doctorName);
    await pref.setString(PreferenceKeys.adminDoctorPhone, doctorPhone);
  }

  /// Clears the admin session from SharedPreferences and signs out.
  Future<void> logout() async {
    await _auth.signOut();
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(PreferenceKeys.adminLogin, false);
    await pref.remove(PreferenceKeys.adminDoctorId);
    await pref.remove(PreferenceKeys.adminDoctorName);
    await pref.remove(PreferenceKeys.adminDoctorPhone);
  }
}
