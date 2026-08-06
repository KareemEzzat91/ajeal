import 'package:ajeal/core/di/service_locator.dart';
import 'package:ajeal/features/admin/children/data/child_repository.dart';
import 'package:ajeal/features/admin/children/presentation/cubit/child_detail/child_detail_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildDetailCubit extends Cubit<ChildDetailState> {
  ChildDetailCubit({ChildRepository? repository, FirebaseAuth? auth})
      : _repository = repository ?? sl<ChildRepository>(),
        _auth = auth ?? FirebaseAuth.instance,
        super(ChildDetailInitial());

  final ChildRepository _repository;
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
      final uid = isOthers && otherDoctorId != null ? otherDoctorId : _auth.currentUser?.uid;
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
