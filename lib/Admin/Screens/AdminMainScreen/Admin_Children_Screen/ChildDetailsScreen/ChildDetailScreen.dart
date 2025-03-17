import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenSelectGooals/GoalDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/AllDetailsScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/DailyNotesScreen/DailyNotesScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/SessionDetailScreen/SessionDetailScreen.dart';
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

  const ChildDetailScreen({
    super.key,
    required this.childName,
    required this.birthDate,
    required this.goals,
    required this.progress,
    required this.child,
  });

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
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          onPressed: () {
            context.read<AddChildCubit>().lastChattedWith=childName;
            context.read<AddChildCubit>().updateUserInfo(key: "lastChattedWith", value: childName);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => ChatScreen(
                  role: "doctor",
                  chatId: adminId! + child.parentPhone,
                  doctorId: adminId,
                  parentId: child.parentPhone,
                  isParent: false,
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
                  builder: (context) => DailyNotesScreen(
                    userType: 'Doctor',
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

            _buildHeaderSection(),
            _buildInfoSection(theme,context),
            _buildSessionsSection(context),
            _buildGoalsSection(context),
            _buildProgressSection(theme.primaryColor),
          ],
        ),
      ),
    ),
);
  }

  Widget _buildHeaderSection() {
    return Container(
      color: Colors.blue[700],
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Center(
        child: Hero(
          tag: 'child_avatar_${child.id}${child.name}',
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                child.gender == "Male"
                    ? "https://img.freepik.com/premium-photo/professional-portrait-studio-photograph-adorable-mixedrace-child-generative-ai_895561-2847.jpg"
                    : "https://avatarfiles.alphacoders.com/143/143832.jpg",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(theme,context ) {
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
          _buildInfoRow(Icons.person, "اسم الطفل", childName),
          const Divider(height: 24),
          _buildInfoRow(Icons.cake, "تاريخ الميلاد", birthDate),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.calendar_today,
            "تاريخ البداية",
            "${child.startDate.year}-${child.startDate.month}-${child.startDate.day}",
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.event,
            "تاريخ النهاية",
            "${child.endDate.year}-${child.endDate.month}-${child.endDate.day}",
          ),
          const Divider(height: 24),
          GestureDetector(
            onTap: (){ Navigator.push(context , MaterialPageRoute(builder: (context )=>AllDetailsScreen(child)));},
            child: _buildInfoRow(
              Icons.align_horizontal_left,
              "باقي التفاصيل ",
              "اضغط هنا "
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
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

  Widget _buildSessionsSection(BuildContext context) {
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
                context, session, index, Theme.of(context).primaryColor);
          },
        ),
      ],
    );
  }

  Widget _buildSessionCard(BuildContext context, Map<String, dynamic> session,
      int index, primaryColor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: BlocBuilder<AddChildCubit, AddChildState>(
  builder: (context, state) {
    return InkWell(
        onTap: () {
          context.read<AddChildCubit>().updateUserInfo(key: "", value: "");
          _navigateToSessionDetail(context, session);},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text('${index + 1}'),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionDetailScreen(
          childName: childName,

          isParent: false,
          childId: child.parentPhone,
          sessionName: session['session'],
          date: session['date'],
          goals: List<String>.from(session['goals']),
          notes: session['notes'] ?? '',
          rate: session['rate'] ?? 0.0,
          tasks: List.from(session['tasks'] ?? []),
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
          onTap: () => Navigator.push(
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
                  "https://www.ces-schools.net/wp-content/uploads/2020/07/AdobeStock_234287116-1024x683.jpeg",
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

  Widget _buildProgressSection(theme) {
    final progressValue = double.tryParse(progress) ?? 0.5;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme,
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
          const Text(
            "التقدم الحالي",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue[700],
                  minHeight: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${(progressValue * 100).toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
