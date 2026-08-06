import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/child_repository.dart';
import 'children_list_state.dart';

/// Cubit responsible for loading and filtering the children list.
/// Replaces the list-management responsibilities previously in AddChildCubit.
class ChildrenListCubit extends Cubit<ChildrenListState> {
  ChildrenListCubit({ChildRepository? repository, FirebaseAuth? auth})
      : _repository = repository ?? sl<ChildRepository>(),
        _auth = auth ?? FirebaseAuth.instance,
        super(ChildrenListInitial());

  final ChildRepository _repository;
  final FirebaseAuth _auth;

  String? get _userId => _auth.currentUser?.uid;

  /// Loads the doctor's own children list.
  Future<void> loadChildren() async {
    final userId = _userId;
    if (userId == null) {
      emit(ChildrenListError('User not authenticated'));
      return;
    }

    emit(ChildrenListLoading());
    try {
      final children = await _repository.fetchChildren(userId);
      final current =
          state is ChildrenListLoaded ? (state as ChildrenListLoaded) : null;
      emit(ChildrenListLoaded(
        children: children,
        othersChildren: current?.othersChildren ?? [],
        filter: current?.filter ?? 'all',
      ));
    } catch (e) {
      emit(ChildrenListError(e.toString()));
    }
  }

  /// Loads children from other doctors.
  Future<void> loadOthersChildren() async {
    final userId = _userId;
    if (userId == null) {
      emit(ChildrenListError('User not authenticated'));
      return;
    }

    emit(ChildrenListLoading());
    try {
      final othersChildren = await _repository.fetchOthersChildren(userId);
      final current =
          state is ChildrenListLoaded ? (state as ChildrenListLoaded) : null;
      emit(ChildrenListLoaded(
        children: current?.children ?? [],
        othersChildren: othersChildren,
        filter: current?.filter ?? 'Others',
      ));
    } catch (e) {
      emit(ChildrenListError(e.toString()));
    }
  }

  /// Changes the active filter and reloads data if needed.
  Future<void> setFilter(String filter) async {
    if (state is ChildrenListLoaded) {
      final current = state as ChildrenListLoaded;
      emit(current.copyWith(filter: filter));

      if (filter == 'Others' && current.othersChildren.isEmpty) {
        await loadOthersChildren();
      } else if (filter != 'Others' && current.children.isEmpty) {
        await loadChildren();
      }
    } else {
      if (filter == 'Others') {
        await loadOthersChildren();
      } else {
        await loadChildren();
      }
    }
  }
}
