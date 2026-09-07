import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:ajeal/features/admin/children/presentation/screens/child_details_screen/daily_notes_screen/daily_notes_cubit.dart';
import 'package:ajeal/features/admin/children/presentation/screens/child_details_screen/daily_notes_screen/daily_notes_state.dart';
import 'package:ajeal/features/admin/children/presentation/screens/child_details_screen/daily_notes_screen/date_navigation_button.dart';
import 'package:ajeal/features/admin/children/presentation/screens/child_details_screen/daily_notes_screen/empty_state.dart';
import 'package:ajeal/features/admin/children/presentation/screens/child_details_screen/daily_notes_screen/note_card.dart';
import 'package:ajeal/features/admin/children/presentation/screens/child_details_screen/daily_notes_screen/ui_helpers.dart';

class DailyNotesScreen extends StatelessWidget {
  final String userType;
  final String childID;
  final bool isOthers;
  final String? otherDoctorId;

  const DailyNotesScreen({
    super.key,
    required this.userType,
    required this.childID,
    required this.isOthers,
    this.otherDoctorId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DailyNotesCubit(
        childId: childID,
        userType: userType,
        isOthers: isOthers,
        otherDoctorId: otherDoctorId,
      )..loadNotes(),
      child: const DailyNotesView(),
    );
  }
}

class DailyNotesView extends StatefulWidget {
  const DailyNotesView({super.key});

  @override
  State<DailyNotesView> createState() => _DailyNotesViewState();
}

class _DailyNotesViewState extends State<DailyNotesView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<DailyNotesCubit>().setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).primaryColor;
    final cubit = context.read<DailyNotesCubit>();

    return BlocConsumer<DailyNotesCubit, DailyNotesState>(
      listener: (context, state) {
        if (state is DailyNotesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme,
          appBar: _buildAppBar(theme, cubit.userType),
          body: Column(
            children: [
              _buildSearchAndDateNavigation(theme, cubit, state),
              _buildNotesList(cubit, state),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddNoteDialog(cubit),
            backgroundColor: Colors.blue,
            icon: const Icon(Icons.add),
            label: const Text('Add Note'),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(Color theme, String userType) {
    return AppBar(
      elevation: 0,
      backgroundColor: theme,
      title: Text(
        "Daily Notes",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CircleAvatar(
            backgroundColor: UIHelpers.getSenderColor(userType),
            child: Icon(
              UIHelpers.getSenderIcon(userType),
              color: UIHelpers.getSenderIconColor(userType),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndDateNavigation(
      Color theme, DailyNotesCubit cubit, DailyNotesState state) {
    DateTime selectedDate = DateTime.now();
    if (state is DailyNotesLoaded) {
      selectedDate = state.selectedDate;
    }

    return Container(
      color: theme,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search notes...",
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Date Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DateNavigationButton(
                icon: Icons.arrow_back_ios,
                onPressed: () {
                  cubit.setSelectedDate(
                      selectedDate.subtract(const Duration(days: 1)));
                },
              ),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    cubit.setSelectedDate(picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMM dd, yyyy').format(selectedDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DateNavigationButton(
                icon: Icons.arrow_forward_ios,
                onPressed: () {
                  cubit.setSelectedDate(
                      selectedDate.add(const Duration(days: 1)));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(DailyNotesCubit cubit, DailyNotesState state) {
    if (state is DailyNotesLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is DailyNotesLoaded) {
      final filteredNotes = cubit.getFilteredNotes();
      if (filteredNotes.isEmpty) {
        return const Expanded(child: EmptyState());
      }

      return Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            final note = filteredNotes[index];
            return NoteCard(
              note: note,
              userType: cubit.userType,
              onDelete: () => cubit.deleteNote(note.id),
              senderColor: UIHelpers.getSenderColor(note.sender),
              senderIcon: UIHelpers.getSenderIcon(note.sender),
              senderIconColor: UIHelpers.getSenderIconColor(note.sender),
            );
          },
        ),
      );
    }

    // For initial or error states
    return const Expanded(
      child: Center(child: Text("Load notes to get started")),
    );
  }

  Future<void> _showAddNoteDialog(DailyNotesCubit cubit) async {
    _noteController.clear();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Add Note",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        content: TextField(
          controller: _noteController,
          decoration: InputDecoration(
            hintText: "Enter note",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.addNote(_noteController.text);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
