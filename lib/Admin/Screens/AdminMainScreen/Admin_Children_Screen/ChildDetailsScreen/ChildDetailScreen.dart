import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenSelectGooals/GoalDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/DailyNotesScreen/DailyNotesScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/SessionDetailScreen/SessionDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/child_header.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/child_info.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/child_proggress.dart';
import 'package:ajeal/Admin/models/ChildModel/ChildModel.dart';
import 'package:ajeal/Admin/models/goals_model/Goals.dart';
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/ParentAdminchat/ParentAdminchatscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildDetailScreen extends StatelessWidget {
  final Child child;
  final String childName;
  final String birthDate;
  final List<Goal> goals;
  final String progress;
  final bool isOthers;

  ChildDetailScreen({
    super.key,
    required this.childName,
    required this.birthDate,
    required this.goals,
    required this.progress,
    required this.isOthers,
    required this.child,
  });


  int completedSessions =0;
  @override
  Widget build(BuildContext context) {
    final String? adminId = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => AddChildCubit(),
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: AppBar(
          title: Text(
            "تفاصيل $childName",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          leading: BlocBuilder<AddChildCubit, AddChildState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(
                    Icons.chat_bubble_outline, color: Colors.white),
                onPressed: () {
                  context
                      .read<AddChildCubit>()
                      .lastChattedWith = childName;
                  context.read<AddChildCubit>().updateUserInfo(
                    isOthers: isOthers,
                      key: "lastChattedWith", value: childName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) =>
                          ChatScreen(
                            isOthers: isOthers,
                            role: "doctor",
                            doctorId: adminId!,
                            parentId: child.parentPhone,
                            isParent: false,
                            doctorOthersId: isOthers ? child.doctorId : null,
                          ),
                    ),
                  );
                },
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.note_add_outlined, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DailyNotesScreen(
                          isOthers: isOthers,
                          otherDoctorId: child.doctorId,
                          userType: isOthers ? "Teacher" : 'Doctor',
                          childID: child.parentPhone,

                        ),
                  ),
                );
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
              ChildInfoSection(theme: theme, context: context, birthDate: birthDate, child: child),
              _buildSessionsSection(context,child),
              _buildGoalsSection(context),
              ProgressSection(child: child,theme:theme.primaryColor,),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSessionsSection(BuildContext context,Child child ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "الجلسات",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: child.scheduleSesoins.length,
          itemBuilder: (context, index) {
            final session = child.scheduleSesoins[index];
            return _buildSessionCard(
                context, session, index, Theme
                .of(context)
                .primaryColor);
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
      child: BlocBuilder<AddChildCubit, AddChildState>(
        builder: (context, state) {
          // Fixed the incomplete conditional expression
          final bool isCompleted = session["completed"] ?? false;

          return InkWell(
            onTap: () {
              context.read<AddChildCubit>().updateUserInfo(isOthers: isOthers,key: "lastSessionWith", value: childName);
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
                        backgroundColor: isCompleted
                            ? Colors.green[100]
                            : Colors.blue[100],
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
                              'جلسة: ${session['session']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'التاريخ: ${session['date']}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            // Added completion status text
                            if (isCompleted)
                              Text(
                                'مكتمل',
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

  void _navigateToSessionDetail(BuildContext context,
      Map<String, dynamic> session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SessionDetailScreen(
              childName: childName,

              isParent: false,
              childId: child.parentPhone,
              sessionName: session['session'],
              date: session['date'],
              goals: List<String>.from(session['goals']),
              notes: session['notes'] ?? '',
              rate: session['rate'] ?? 0.0,
              tasks: List.from(session['tasks'] ?? []),
              isCompleted:session['completed']??false,
              isOthers: isOthers,
              doctorId: child.doctorId,
              completedSessions: completedSessions,


            ),
      ),
    );
  }

  Widget _buildGoalsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "الأهداف",
            style: TextStyle(
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
          onTap: () =>
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalDetailScreen(goal: goal),
                ),
              ),
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
