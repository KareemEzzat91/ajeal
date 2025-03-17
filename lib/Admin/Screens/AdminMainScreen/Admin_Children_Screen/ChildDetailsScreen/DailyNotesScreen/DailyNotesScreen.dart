import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Data model for better type safety and organization
class Note {
  final String id;
  final String text;
  final DateTime date;
  final String sender;

  Note({
    required this.id,
    required this.text,
    required this.date,
    required this.sender,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      sender: map['sender'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': Timestamp.fromDate(date),
      'sender': sender,
    };
  }
}

class DailyNotesScreen extends StatefulWidget {
  final String userType;
  final String childID;

  const DailyNotesScreen({
    super.key,
    required this.userType,
    required this.childID,
  });

  @override
  _DailyNotesScreenState createState() => _DailyNotesScreenState();
}

class _DailyNotesScreenState extends State<DailyNotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("DailyNotes")
          .doc(widget.childID)
          .get();

      if (snapshot.exists && snapshot.data()?['notes'] != null) {
        final notesData =
            List<Map<String, dynamic>>.from(snapshot.data()!['notes']);
        setState(() {
          notes = notesData.map((note) => Note.fromMap(note)).toList();
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error loading notes: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> addNote() async {
    if (_noteController.text.isEmpty) return;

    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _noteController.text,
      date: selectedDate,
      sender: widget.userType,
    );

    setState(() {
      notes.add(newNote);
      _noteController.clear();
    });

    await saveDailyNotes();
  }

  Future<void> saveDailyNotes() async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final notesData = notes.map((note) => note.toMap()).toList();

      // Save to DailyNotes collection
      batch.set(
        FirebaseFirestore.instance.collection("DailyNotes").doc(widget.childID),
        {"notes": notesData},
      );

      // Save to user's children collection
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        batch.update(
          FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("children")
              .doc(widget.childID),
          {"dailyNotes": notesData},
        );
        batch.update(FirebaseFirestore.instance.collection("Children").doc(widget.childID),  {"dailyNotes": notesData},);
      }

      await batch.commit();
    } catch (e) {
      _showErrorSnackBar('Error saving note: $e');
    }
  }

  List<Note> getFilteredNotes() {
    return notes.where((note) {
      final sameDate = DateFormat('yyyy-MM-dd').format(note.date) ==
          DateFormat('yyyy-MM-dd').format(selectedDate);
      final matchesSearch = note.text
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      return sameDate && matchesSearch;
    }).toList();
  }

  Color getSenderColor(String sender) {
    switch (sender) {
      case 'Doctor':
        return Colors.blue.shade50;
      case 'Teacher':
        return Colors.green.shade50;
      case 'Parent':
        return Colors.orange.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color getSenderIconColor(String sender) {
    switch (sender) {
      case 'Doctor':
        return Colors.blue;
      case 'Teacher':
        return Colors.green;
      case 'Parent':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData getSenderIcon(String sender) {
    switch (sender) {
      case 'Doctor':
        return Icons.medical_services;
      case 'Teacher':
        return Icons.school;
      case 'Parent':
        return Icons.family_restroom;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).primaryColor;
    return Scaffold(
        backgroundColor: theme,
        appBar: AppBar(
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
                backgroundColor: getSenderColor(widget.userType),
                child: Icon(
                  getSenderIcon(widget.userType),
                  color: getSenderIconColor(widget.userType),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
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
                        prefixIcon:
                            Icon(Icons.search, color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Date Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _DateNavigationButton(
                        icon: Icons.arrow_back_ios,
                        onPressed: () {
                          setState(() {
                            selectedDate =
                                selectedDate.subtract(const Duration(days: 1));
                          });
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
                            setState(() => selectedDate = picked);
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
                      _DateNavigationButton(
                        icon: Icons.arrow_forward_ios,
                        onPressed: () {
                          setState(() {
                            selectedDate =
                                selectedDate.add(const Duration(days: 1));
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : getFilteredNotes().isEmpty
                      ? _EmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: getFilteredNotes().length,
                          itemBuilder: (context, index) {
                            final note = getFilteredNotes()[index];
                            return _NoteCard(
                              note: note,
                              userType: widget.userType,
                              onDelete: () async {
                                setState(() {
                                  notes.removeWhere((n) => n.id == note.id);
                                });
                                await saveDailyNotes();
                              },
                              senderColor: getSenderColor(note.sender),
                              senderIcon: getSenderIcon(note.sender),
                              senderIconColor: getSenderIconColor(note.sender),
                            );
                          },
                        ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddNoteDialog(),
          backgroundColor: Colors.blue,
          icon: const Icon(Icons.add),
          label: const Text('Add Note'),
        ));
  }

  Future<void> _showAddNoteDialog() async {
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
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addNote();
              Navigator.pop(context);
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

class _DateNavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _DateNavigationButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: Icon(icon, size: 18),
        color: Colors.grey.shade600,
        onPressed: onPressed,
      ),
    );
  }
}

// Continue from the previous code, fixing the _NoteCard class and adding the missing _EmptyState class

class _NoteCard extends StatelessWidget {
  final Note note;
  final String userType;
  final VoidCallback onDelete;
  final Color senderColor;
  final IconData senderIcon;
  final Color senderIconColor;

  const _NoteCard({
    required this.note,
    required this.userType,
    required this.onDelete,
    required this.senderColor,
    required this.senderIcon,
    required this.senderIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: senderColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(senderIcon, color: senderIconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  note.sender,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('hh:mm a').format(note.date),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                if (userType == note.sender) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: Colors.red.shade400,
                    onPressed: onDelete,
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              note.text,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_alt_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No notes for this date",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Notes you add will appear here",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
