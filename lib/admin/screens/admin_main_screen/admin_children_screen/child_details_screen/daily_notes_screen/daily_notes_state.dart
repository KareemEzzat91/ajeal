// cubits/daily_notes_state.dart
import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/child_details_screen/daily_notes_screen/note_model.dart';
import 'package:equatable/equatable.dart';

abstract class DailyNotesState extends Equatable {
  const DailyNotesState();

  @override
  List<Object?> get props => [];
}

class DailyNotesInitial extends DailyNotesState {}

class DailyNotesLoading extends DailyNotesState {}

class DailyNotesLoaded extends DailyNotesState {
  final List<Note> notes;
  final DateTime selectedDate;
  final String searchQuery;

  const DailyNotesLoaded({
    required this.notes,
    required this.selectedDate,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [notes, selectedDate, searchQuery];

  DailyNotesLoaded copyWith({
    List<Note>? notes,
    DateTime? selectedDate,
    String? searchQuery,
  }) {
    return DailyNotesLoaded(
      notes: notes ?? this.notes,
      selectedDate: selectedDate ?? this.selectedDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class DailyNotesError extends DailyNotesState {
  final String message;

  const DailyNotesError(this.message);

  @override
  List<Object> get props => [message];
}