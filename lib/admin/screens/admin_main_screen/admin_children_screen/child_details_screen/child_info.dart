import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/child_details_screen/all_details_screen.dart';
import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChildInfoSection extends StatelessWidget {
  const ChildInfoSection({
    super.key,
    required this.theme,
    required this.context,
    required this.birthDate,
    required this.child,
  });

  final dynamic theme;
  final dynamic context;
  final String birthDate;
  final Child child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChildInforRow(icon: Icons.person, label: S.of(context).name, value: child.name),
          const Divider(height: 24),
          ChildInforRow(icon: Icons.cake, label: S.of(context).dateOfBirth, value: birthDate),
          const Divider(height: 24),
          ChildInforRow(icon: Icons.calendar_today, label: S.of(context).startDate, value: "${child.startDate.year}-${child.startDate.month}-${child.startDate
              .day}"),
          const Divider(height: 24),
          ChildInforRow(icon: Icons.event, label:S.of(context).endDate, value: "${child.endDate.year}-${child.endDate.month}-${child.endDate.day}"),
          const Divider(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AllDetailsScreen(child)));
            },
            child:  ChildInforRow(icon: Icons.align_horizontal_left, label:S.of(context).detailedReports, value: S.of(context).press),
          ),

        ],
      ),
    );
  }
}

class ChildInforRow extends StatelessWidget {
  const ChildInforRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}