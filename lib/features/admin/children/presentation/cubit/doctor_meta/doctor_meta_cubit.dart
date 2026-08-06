import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/service_locator.dart';
import '../../../data/doctor_repository.dart';
import 'doctor_meta_state.dart';

/// Cubit for updating doctor metadata fields (lastSessionWith, taskAddedFor, etc).
/// Replaces the updateUserInfo / getUserInfo responsibilities previously in AddChildCubit.
class DoctorMetaCubit extends Cubit<DoctorMetaState> {
  DoctorMetaCubit({DoctorRepository? repository, FirebaseAuth? auth})
      : _repository = repository ?? getIt<DoctorRepository>(),
        _auth = auth ?? FirebaseAuth.instance,
        super(DoctorMetaInitial());

  final DoctorRepository _repository;
  final FirebaseAuth _auth;

  String? get _userId => _auth.currentUser?.uid;

  /// Updates a single [key] with [value] on the doctor document.
  /// No-op when [isOthers] is true (read-only view of another doctor's child).
  Future<void> updateField({
    required String key,
    required String value,
    required bool isOthers,
  }) async {
    if (isOthers) return;
    final userId = _userId;
    if (userId == null) return;

    try {
      emit(DoctorMetaUpdating());
      await _repository.updateDoctorField(userId, key, value);
      emit(DoctorMetaUpdated());
    } catch (e) {
      emit(DoctorMetaError(e.toString()));
    }
  }
}
