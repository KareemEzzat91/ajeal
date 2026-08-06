import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChildQuickStats extends StatelessWidget {
  const ChildQuickStats({
    super.key,
    required this.child,
    required this.context,
  });

  final Child child;
  final dynamic context;

  @override
  Widget build(BuildContext context) {
   final double progress=  (child.completedSessions/child.scheduleSessions.length)*100 ;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ChildStatsBuilder(title: S.of(context).sessions, value: "${child.scheduleSessions.length}", icon: Icons.calendar_today, color: Colors.blue),
        ChildStatsBuilder(title: S.of(context).goals, value: "${child.selectedGoals.length}", icon: Icons.track_changes, color: Colors.green),
        ChildStatsBuilder(title: S.of(context).progress, value: "${progress.toStringAsFixed(0)}%", icon: Icons.trending_up, color: Colors.orange),
      ],
    );
  }
}

class ChildStatsBuilder extends StatelessWidget {
  const ChildStatsBuilder({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}