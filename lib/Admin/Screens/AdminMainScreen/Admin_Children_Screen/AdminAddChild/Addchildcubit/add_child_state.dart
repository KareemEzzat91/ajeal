part of 'add_child_cubit.dart';

@immutable
sealed class AddChildState {}

final class AddChildInitial extends AddChildState {}
final class AddScuccesState extends AddChildState {}
final class AddFailureState extends AddChildState {}
final class AddLoadingState extends AddChildState {}
final class NumberofItemsPlusstate extends AddChildState {}
