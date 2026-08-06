import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../admin/screens/admin_main_screen/admin_children_screen/child_details_screen/daily_notes_screen/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final String userType;
  final VoidCallback onDelete;
  final Color senderColor;
  final IconData senderIcon;
  final Color senderIconColor;

  const NoteCard({
    super.key,
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
