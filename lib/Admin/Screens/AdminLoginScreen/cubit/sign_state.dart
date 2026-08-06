part of 'sign_cubit.dart';

@immutable
sealed class SignState {}

final class SignInitial extends SignState {}

final class SignSuccessState extends SignState {}

final class SignLoadingState extends SignState {}

final class SignFailureState extends SignState {
  final error;
  SignFailureState(this.error);
}
