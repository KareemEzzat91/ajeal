sealed class DoctorMetaState {}

final class DoctorMetaInitial extends DoctorMetaState {}

/// Emitted while a Firestore update is in progress.
final class DoctorMetaUpdating extends DoctorMetaState {}

/// Emitted after a successful field update.
final class DoctorMetaUpdated extends DoctorMetaState {}

/// Emitted when an update fails.
final class DoctorMetaError extends DoctorMetaState {
  final String message;
  DoctorMetaError(this.message);
}
