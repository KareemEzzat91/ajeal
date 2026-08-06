import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../admin/screens/admin_main_screen/admin_children_screen/child_details_screen/daily_notes_screen/note_model.dart';
import '../../../../../../admin/screens/admin_main_screen/admin_children_screen/child_details_screen/daily_notes_screen/notes_repository.dart';
import 'daily_notes_state.dart';

class DailyNotesCubit extends Cubit<DailyNotesState> {
  final NotesRepository _repository;
  final String childId;
  final String userType;
  final bool isOthers;
  final String? otherDoctorId;

  DailyNotesCubit({
    required this.childId,
    required this.userType,
    required this.isOthers,
    this.otherDoctorId,
    NotesRepository? repository,
  })  : _repository = repository ?? NotesRepository(),
        super(DailyNotesInitial());

  Future<void> loadNotes() async {
    emit(DailyNotesLoading());

    try {
      final notes = await _repository.loadNotes(childId);
      emit(DailyNotesLoaded(
        notes: notes,
        selectedDate: DateTime.now(),
      ));
    } catch (e) {
      emit(DailyNotesError('Failed to load notes: $e'));
    }
  }

  Future<void> addNote(String text) async {
    if (text.isEmpty) return;

    if (state is DailyNotesLoaded) {
      final currentState = state as DailyNotesLoaded;
      final notes = List<Note>.from(currentState.notes);

      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        date: currentState.selectedDate,
        sender: userType,
      );

      notes.add(newNote);

      // Optimistically update UI
      emit(currentState.copyWith(notes: notes));

      try {
        await _repository.saveNotes(childId, notes, isOthers, otherDoctorId);
      } catch (e) {
        // Rollback if save fails
        notes.remove(newNote);
        emit(currentState.copyWith(notes: notes));
        emit(DailyNotesError('Failed to save note: $e'));
        emit(currentState); // Return to previous state after showing error
      }
    }
  }

  Future<void> deleteNote(String noteId) async {
    if (state is DailyNotesLoaded) {
      final currentState = state as DailyNotesLoaded;
      final notes = List<Note>.from(currentState.notes);
      final noteToRemove = notes.firstWhere((note) => note.id == noteId);

      notes.removeWhere((note) => note.id == noteId);

      // Optimistically update UI
      emit(currentState.copyWith(notes: notes));

      try {
        await _repository.saveNotes(childId, notes, isOthers, otherDoctorId);
      } catch (e) {
        // Rollback if delete fails
        notes.add(noteToRemove);
        emit(currentState.copyWith(notes: notes));
        emit(DailyNotesError('Failed to delete note: $e'));
        emit(currentState); // Return to previous state after showing error
      }
    }
  }

  void setSelectedDate(DateTime date) {
    if (state is DailyNotesLoaded) {
      final currentState = state as DailyNotesLoaded;
      emit(currentState.copyWith(selectedDate: date));
    }
  }

  void setSearchQuery(String query) {
    if (state is DailyNotesLoaded) {
      final currentState = state as DailyNotesLoaded;
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  List<Note> getFilteredNotes() {
    if (state is DailyNotesLoaded) {
      final currentState = state as DailyNotesLoaded;
      return currentState.notes.where((note) {
        final sameDate = DateFormat('yyyy-MM-dd').format(note.date) ==
            DateFormat('yyyy-MM-dd').format(currentState.selectedDate);
        final matchesSearch = note.text
            .toLowerCase()
            .contains(currentState.searchQuery.toLowerCase());
        return sameDate && matchesSearch;
      }).toList();
    }
    return [];
  }
}
