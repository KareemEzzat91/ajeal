import 'package:ajeal/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/helpers/generated/l10n.dart';

class ChildActionCards extends StatelessWidget {
  const ChildActionCards({
    super.key,
    required this.child,
    required this.adminId,
    required this.parentCode,
    required this.context,
  });

  final Child child;
  final String adminId;
  final String parentCode;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChildActionCardBuilder(
            context: context,
            title: S.of(context).childDetails,
            subtitle: S.of(context).detailedReports,
            icon: Icons.person,
            color: Colors.red,
            onTap: () => context
                .push(Routes.adminChildrenDetailsAll, extra: {'child': child})),
        const SizedBox(height: 16),
        ChildActionCardBuilder(
            context: context,
            title: S.of(context).view_child_goals,
            subtitle: S.of(context).track_progress,
            icon: Icons.flag,
            color: Colors.orange,
            onTap: () =>
                context.push(Routes.parentChildGoals, extra: {'child': child})),
        const SizedBox(height: 16),
        ChildActionCardBuilder(
            context: context,
            title: S.of(context).schedule_sessions,
            subtitle: S.of(context).manage_sessions,
            icon: Icons.calendar_today,
            color: Colors.purple,
            onTap: () => context
                .push(Routes.parentSessionSchedule, extra: {'child': child})),
        const SizedBox(height: 16),
        ChildActionCardBuilder(
            context: context,
            title: S.of(context).chat_teacher,
            subtitle: S.of(context).direct_communication,
            icon: Icons.chat,
            color: Colors.blue,
            onTap: () => context.push(Routes.parentChat, extra: {
                  'isOthers': false,
                  'role': 'parent',
                  'isParent': true,
                  'doctorId': adminId,
                  'parentId': child.parentPhone
                })),
        const SizedBox(height: 16),
        ChildActionCardBuilder(
            context: context,
            title: S.of(context).global_chat,
            subtitle: S.of(context).connect_community,
            icon: Icons.people,
            color: Colors.green,
            onTap: () => context.push(Routes.parentGlobalChat, extra: {
                  'childName': child.name,
                  'isParent': true,
                  'doctorId': adminId,
                  'parentId': child.parentPhone
                })),
        const SizedBox(height: 16),
        ChildActionCardBuilder(
            context: context,
            title: S.of(context).daily_notes,
            subtitle: S.of(context).write_daily_notes,
            icon: Icons.note_add_sharp,
            color: Colors.brown,
            onTap: () => context.push(Routes.adminChildrenDetailsDailyNotes,
                    extra: {
                      'isOthers': false,
                      'childID': parentCode,
                      'userType': "Parent"
                    })),
      ],
    );
  }
}

class ChildActionCardBuilder extends StatelessWidget {
  const ChildActionCardBuilder({
    super.key,
    required this.context,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final BuildContext context;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
