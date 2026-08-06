import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChildProgressSection extends StatelessWidget {
  const ChildProgressSection({
    super.key,
    required this.child,
    required this.context,
  });

  final Child child;
  final dynamic context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).progress_overview,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white ,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProgressDetail(label: S.of(context).completed, value: "${child.completedSessions}"),
              ProgressDetail(label: S.of(context).in_progress, value: "${child.scheduleSessions.length-child.completedSessions}"),
              ProgressDetail(label: S.of(context).upcoming, value:"${child.completedSessions+1}"),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressDetail extends StatelessWidget {
  const ProgressDetail({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white ,
          ),
        ),
      ],
    );
  }
}
