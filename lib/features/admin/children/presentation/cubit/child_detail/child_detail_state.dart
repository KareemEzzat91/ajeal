import 'package:equatable/equatable.dart';

abstract class ChildDetailState extends Equatable {
  const ChildDetailState();

  @override
  List<Object?> get props => [];
}

class ChildDetailInitial extends ChildDetailState {}

class ChildDetailLoading extends ChildDetailState {}

class ChildDetailSuccess extends ChildDetailState {
  final String message;
  const ChildDetailSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ChildDetailFailure extends ChildDetailState {
  final String error;
  const ChildDetailFailure(this.error);

  @override
  List<Object?> get props => [error];
}
