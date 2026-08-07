import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ajeal/core/di/service_locator.dart';
import 'package:ajeal/features/admin/children/data/child_repository.dart';
import 'package:ajeal/features/admin/children/data/doctor_repository.dart';
import 'package:ajeal/features/admin/children/presentation/cubit/child_detail/child_detail_state.dart';

class ChildDetailCubit extends Cubit<ChildDetailState> {
  ChildDetailCubit(
      {ChildRepository? repository,
      DoctorRepository? doctorRepository,
      FirebaseAuth? auth})
      : _repository = repository ?? getIt<ChildRepository>(),
        _doctorRepo = doctorRepository ?? getIt<DoctorRepository>(),
        _auth = auth ?? FirebaseAuth.instance,
        super(ChildDetailInitial());

  final ChildRepository _repository;
  final DoctorRepository _doctorRepo;
  final FirebaseAuth _auth;

  Future<void> deleteChild(String parentPhone, bool isOthers) async {
    emit(ChildDetailLoading());
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');
      await _repository.deleteChild(userId, parentPhone, isOthers);
      emit(const ChildDetailSuccess('Child deleted successfully'));
    } catch (e) {
      emit(ChildDetailFailure(e.toString()));
    }
  }

  Future<void> saveSessionDetails({
    required String childId,
    required bool isOthers,
    required String? otherDoctorId,
    required Map<String, dynamic> sessionData,
    required int sessionName,
    required bool isCompleted,
    required int completedSessions,
  }) async {
    emit(ChildDetailLoading());
    try {
      String? uid;
      if (isOthers && otherDoctorId != null) {
        // Resolve the actual uid via the repository — no raw Firestore in the screen.
        uid = await _doctorRepo.resolveDoctorUid(otherDoctorId);
      }
      uid ??= _auth.currentUser?.uid;
      if (uid == null) throw Exception('Doctor ID not found');

      await _repository.updateSession(
        doctorId: uid,
        childId: childId,
        sessionName: sessionName,
        sessionData: sessionData,
        isCompleted: isCompleted,
        completedSessions: completedSessions,
      );
      emit(const ChildDetailSuccess('Session saved successfully'));
    } catch (e) {
      emit(ChildDetailFailure(e.toString()));
    }
  }
}
