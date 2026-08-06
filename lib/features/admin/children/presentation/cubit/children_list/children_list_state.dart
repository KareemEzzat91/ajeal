import 'package:ajeal/core/models/child_model/child_model.dart';

sealed class ChildrenListState {}

final class ChildrenListInitial extends ChildrenListState {}

final class ChildrenListLoading extends ChildrenListState {}

final class ChildrenListLoaded extends ChildrenListState {
  final List<Map<String, Child>> children;
  final List<Map<String, Child>> othersChildren;
  final String filter; // 'all' | 'Others' | 'completed' | 'pending'

  ChildrenListLoaded({
    required this.children,
    required this.othersChildren,
    this.filter = 'all',
  });

  ChildrenListLoaded copyWith({
    List<Map<String, Child>>? children,
    List<Map<String, Child>>? othersChildren,
    String? filter,
  }) =>
      ChildrenListLoaded(
        children: children ?? this.children,
        othersChildren: othersChildren ?? this.othersChildren,
        filter: filter ?? this.filter,
      );

  /// Returns the currently visible list based on the active filter.
  List<Map<String, Child>> get visibleChildren =>
      filter == 'Others' ? othersChildren : children;
}

final class ChildrenListError extends ChildrenListState {
  final String message;
  ChildrenListError(this.message);
}
