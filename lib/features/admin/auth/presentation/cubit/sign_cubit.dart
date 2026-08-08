import 'package:ajeal/core/routing/routes.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/di/service_locator.dart';
import 'package:ajeal/features/admin/auth/data/auth_repository.dart';

part 'sign_state.dart';

/// Cubit for admin authentication (login, signup, logout).
/// All Firebase/Firestore calls are delegated to [AuthRepository].
class SignCubit extends Cubit<SignState> {
  SignCubit({AuthRepository? authRepository})
      : _repo = authRepository ?? getIt<AuthRepository>(),
        super(SignInitial());

  final AuthRepository _repo;

  /// Signs in with email and password, then navigates to the admin main screen.
  Future<void> login(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    if (!formKey.currentState!.validate()) {
      emit(SignFailureState('Validation error'));
      return;
    }

    emit(SignLoadingState());
    try {
      final data = await _repo.login(
        emailController.text,
        passwordController.text,
      );

      await _repo.saveAdminSession(
        data['doctorId']!,
        data['doctorName']!,
        data['doctorPhone']!,
      );

      if (!context.mounted) return;
      context.go(Routes.adminMain, extra: data);

      emit(SignSuccessState());
    } catch (e) {
      emit(SignFailureState(e.toString()));
    }
  }

  /// Creates a new doctor account and navigates to the verification screen.
  Future<void> signUp(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController nameController,
    TextEditingController passwordController,
    TextEditingController mobileController,
  ) async {
    if (!formKey.currentState!.validate()) {
      emit(SignFailureState('Validation error'));
      return;
    }

    emit(SignLoadingState());
    try {
      await _repo.signUp(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        mobile: mobileController.text,
      );

      emit(SignFailureState(
          'Your account is created. Please verify your email.'));
      emit(SignSuccessState());
    } catch (e) {
      emit(SignFailureState(e.toString()));
    }
  }

  /// Signs out and clears the session.
  Future<void> logout(BuildContext context) async {
    try {
      await _repo.logout();
      if (!context.mounted) return;
      context.go(Routes.choice);
    } catch (_) {
      // Ignore logout errors — user is being sent to the choice screen anyway.
    }
  }
}
