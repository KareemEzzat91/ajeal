import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/AdminmainScreen/AdminmainScreen.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


part 'sign_state.dart';

class SignCubit extends Cubit<SignState> {
  FirebaseAuth instance = FirebaseAuth.instance;
  SignCubit() : super(SignInitial());
  void Login(BuildContext context,
      GlobalKey<FormState> key,
      TextEditingController emailController,
      TextEditingController passwordController,
      ) async {
    emit(SignLoadingState());
    try {
      // التحقق من صحة النموذج
      if (key.currentState!.validate()) {
        // محاولة تسجيل الدخول باستخدام FirebaseAuth
        final UserCredential response = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User? user = response.user;

        if (user != null) {
          if (user.emailVerified)
            {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminmainScreen()),
          );
            }
          else {
              user.sendEmailVerification();
              emit (SignFaliureState("please verfiy your account check mail"));
          }

          emit(SignSuccesState());
        } else {
          emit(SignFaliureState("Login failed"));
        }
      } else {
        // إذا فشلت عملية التحقق من صحة النموذج
        emit(SignFaliureState("Validation error"));
      }
    } catch (e) {
      // إذا حدث خطأ في عملية تسجيل الدخول
      emit(SignFaliureState(e.toString()));
    }
  }
  void SignUp(
      BuildContext context,
      GlobalKey<FormState> key,
      TextEditingController EmailController,
      TextEditingController nameController,
      TextEditingController passwordController,
      TextEditingController MobileController,
      ) async {
    emit(SignLoadingState());

    try {
      if (key.currentState!.validate()) {
        final UserCredential response = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: EmailController.text,
          password: passwordController.text,
        );

        User? user = response.user;

        if (user != null) {
          user.sendEmailVerification();
          emit (SignFaliureState("your account done please verfiy your account check mail"));
          emit(SignSuccesState());
        } else {
          emit(SignFaliureState("User creation failed"));
        }
      } else {
        emit(SignFaliureState("Validation error"));
      }
    } catch (e) {
      // إرسال حالة الفشل مع رسالة الخطأ
      emit(SignFaliureState(e.toString()));
    }
  }

}
