import 'package:ajeal/Admin/Screens/AdminMainScreen/AdminmainScreen/AdminmainScreen.dart';
import 'package:ajeal/Screens/AdminOrparents/admin_or_parents_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_state.dart';

class SignCubit extends Cubit<SignState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignCubit() : super(SignInitial());

  Future<void> login(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    emit(SignLoadingState());

    if (!formKey.currentState!.validate()) {
      emit(SignFailureState("Validation error"));
      return;
    }

    try {
      final UserCredential response = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final User? user = response.user;
      if (user == null) {
        emit(SignFailureState("Login failed"));
        return;
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        emit(SignFailureState("Please verify your account. Check your email."));
        return;
      }

      final doctorSnapshot =
          await _firestore.collection("users").doc(user.uid).get();

      if (!doctorSnapshot.exists) {
        emit(SignFailureState("User data not found"));
        return;
      }

      final String doctorId = doctorSnapshot['Doctor_id'];
      final String doctorName = doctorSnapshot['Doctor_Name'];
      final String doctorPhone = doctorSnapshot['Doctor_phone'];

      await _firestore.collection("Doctors").doc(doctorId).update({
        "Doctor_id": user.uid,
      });

      await saveAdminSession(doctorId, doctorName, doctorPhone);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AdminMainScreen(
            doctorId: doctorId,
            doctorName: doctorName,
            doctorPhone: doctorPhone,
          ),
        ),
        (Route<dynamic> route) => false,
      );

      emit(SignSuccessState());
    } catch (e) {
      emit(SignFailureState(e.toString()));
    }
  }

  Future<void> saveAdminSession(
      String doctorId, String doctorName, String doctorPhone) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("AdminLogin", true);
      await pref.setString("adminDoctorId", doctorId);
      await pref.setString("adminDoctorName", doctorName);
      await pref.setString("adminDoctorPhone", doctorPhone);
    } catch (e) {
      debugPrint("Error saving token: $e");
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("AdminLogin", false);
      await pref.remove("adminDoctorId");
      await pref.remove("adminDoctorName");
      await pref.remove("adminDoctorPhone");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AdminOrParentsScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }

  Future<void> signUp(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController nameController,
    TextEditingController passwordController,
    TextEditingController mobileController,
  ) async {
    emit(SignLoadingState());

    if (!formKey.currentState!.validate()) {
      emit(SignFailureState("Validation error"));
      return;
    }

    try {
      final UserCredential response =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final User? user = response.user;
      if (user == null) {
        emit(SignFailureState("User creation failed"));
        return;
      }

      final String doctorId =
          "${nameController.text.trim()}${mobileController.text.trim()}";

      await user.sendEmailVerification();
      emit(SignFailureState(
          "Your account is created. Please verify your email."));

      await _firestore.collection("users").doc(user.uid).set({
        'Doctor_Name': nameController.text.trim(),
        'Doctor_id': doctorId.trim(),
        'Doctor_phone': mobileController.text.trim(),
        'lastChildId': 0,
        'lastChattedWith': "",
        'lastChildName': "",
        'lastSessionWith': "",
        'taskAddedFor': "",
      });

      await _firestore.collection("Doctors").doc(doctorId).set({
        "Doctor_id": user.uid,
      });

      await saveAdminSession(
          doctorId, nameController.text.trim(), mobileController.text.trim());

      emit(SignSuccessState());
    } catch (e) {
      emit(SignFailureState(e.toString()));
    }
  }
}
