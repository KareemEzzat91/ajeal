import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../../admin/screens/admin_main_screen/admin_children_screen/child_details_screen/child_header.dart';
import '../../../../../admin/screens/admin_main_screen/admin_children_screen/child_details_screen/child_info.dart';
import '../../../../../admin/screens/admin_main_screen/admin_children_screen/child_details_screen/child_progress.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/models/child_model/child_model.dart';
import '../../../../../core/models/goals_model/goals.dart';
import '../../../../../core/widgets/dialogs.dart';
import '../../../../../features/admin/children/presentation/cubit/child_detail/child_detail_cubit.dart';
import '../../../../../features/admin/children/presentation/cubit/doctor_meta/doctor_meta_cubit.dart';
import '../../../../../features/admin/children/presentation/cubit/doctor_meta/doctor_meta_state.dart';
import '../../../../../helpers/generated/l10n.dart';

class ChildDetailScreen extends StatelessWidget {
  final Child child;
  final String childName;
  final String birthDate;
  final List<Goal> goals;
  final String progress;
  final bool isOthers;

  const ChildDetailScreen({
    super.key,
    required this.childName,
    required this.birthDate,
    required this.goals,
    required this.progress,
    required this.isOthers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final String? adminId = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DoctorMetaCubit()),
        BlocProvider(create: (context) => ChildDetailCubit()),
      ],
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: AppBar(
          title: Text(
            "${S.of(context).details} $childName",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          leading: BlocBuilder<DoctorMetaCubit, DoctorMetaState>(
            builder: (context, state) {
              return IconButton(
                icon:
                    const Icon(Icons.chat_bubble_outline, color: Colors.white),
                onPressed: () {
                  context.read<DoctorMetaCubit>().updateField(
                      isOthers: isOthers,
                      key: "lastChattedWith",
                      value: childName);
                  context.push('/parent/chat', extra: {
                    'isOthers': isOthers,
                    'role': 'doctor',
                    'doctorId': adminId!,
                    'parentId': child.parentPhone,
                    'isParent': false,
                    'doctorOthersId': isOthers ? child.doctorId : null,
                  });
                },
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.note_add_outlined, color: Colors.white),
              onPressed: () {
                context.push('/admin/children/details/daily_notes', extra: {
                  'isOthers': isOthers,
                  'otherDoctorId': child.doctorId,
                  'userType': isOthers ? "Teacher" : 'Doctor',
                  'childID': child.parentPhone
                });
              },
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.blue[700],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ChildHeaderSection(child: child),
              ChildInfoSection(
                  theme: theme,
                  context: context,
                  birthDate: birthDate,
                  child: child),
              _buildSessionsSection(context, child),
              _buildGoalsSection(context),
              ProgressSection(
                child: child,
                theme: theme.primaryColor,
                isOthers: isOthers,
                isAnalysisEmpty: child.analysis.isEmpty,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      showCustomDialog(context, child: child);
                    },
                    icon: const Icon(Icons.change_circle_outlined,
                        color: Colors.blueAccent),
                    label: const Text('Transfer'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        text: 'Do you want to Remove ${child.name}?',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.green,
                        onConfirmBtnTap: () {
                          context
                              .read<ChildDetailCubit>()
                              .deleteChild(child.parentPhone, isOthers)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Deleted Successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            context.pop();
                            context.pop(); // Pop back to list
                          }).catchError((e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                            context.pop();
                          });
                        },
                      );
                    },
                    icon: const Icon(Icons.delete_forever,
                        color: AppColors.error),
                    label: const Text('Remove'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionsSection(BuildContext context, Child child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            S.of(context).sessions,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: child.scheduleSessions.length,
          itemBuilder: (context, index) {
            final session = child.scheduleSessions[index];
            return _buildSessionCard(
                context, session, index, Theme.of(context).primaryColor);
          },
        ),
      ],
    );
  }

  Widget _buildSessionCard(BuildContext context, Map<String, dynamic> session,
      int index, Color primaryColor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: BlocBuilder<DoctorMetaCubit, DoctorMetaState>(
        builder: (context, state) {
          // Fixed the incomplete conditional expression
          final bool isCompleted = session["completed"] ?? false;

          return InkWell(
            onTap: () {
              context.read<DoctorMetaCubit>().updateField(
                  isOthers: isOthers, key: "lastSessionWith", value: childName);
              _navigateToSessionDetail(context, session);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        // Change background color based on completion status
                        backgroundColor:
                            isCompleted ? Colors.green[100] : Colors.blue[100],
                        child: isCompleted
                            ? const Icon(Icons.check, color: Colors.green)
                            : Text('${index + 1}'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${S.of(context).session}: ${session['session']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${S.of(context).startDate}: ${session['date']}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            // Added completion status text
                            if (isCompleted)
                              Text(
                                S.of(context).completed,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  if (session['goals'].isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: (session['goals'] as List).map((goal) {
                        return Chip(
                          label: Text(
                            goal,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: primaryColor,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToSessionDetail(
      BuildContext context, Map<String, dynamic> session) {
    context.push('/admin/children/sessions', extra: {
      'childName': childName,
      'isParent': false,
      'childId': child.parentPhone,
      'sessionName': session['session'],
      'date': session['date'],
      'goals': List<String>.from(session['goals'])
    });
  }

  Widget _buildGoalsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            S.of(context).goals,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              return _buildGoalCard(context, goals[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(BuildContext context, Goal goal, int index) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            context.push('/admin/children/add/goals/detail',
                extra: {'goal': goal});
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  "https://th.bing.com/th/id/OIP.j-y_XOKtbpnI_dDwjSG8QAAAAA?rs=1&pid=ImgDetMain",
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.goalName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      goal.goalDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// AI Results Screen
