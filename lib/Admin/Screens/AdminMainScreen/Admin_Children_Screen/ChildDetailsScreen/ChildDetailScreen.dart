import 'dart:async';
import 'dart:convert';
import 'dart:math';

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
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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

              _buildHeaderSection(),
              _buildInfoSection(theme, context),
              _buildSessionsSection(context),
              _buildGoalsSection(context),
              _buildProgressSection(theme.primaryColor,context),
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

  Widget _buildInfoSection(theme, context) {
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
            "${child.startDate.year}-${child.startDate.month}-${child.startDate
                .day}",
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.event,
            "تاريخ النهاية",
            "${child.endDate.year}-${child.endDate.month}-${child.endDate.day}",
          ),
          const Divider(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AllDetailsScreen(child)));
            },
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

  Widget _buildProgressSection(Color theme,BuildContext context ) {
    // Calculate the progress based on completed sessions
    final int totalSessions = child.scheduleSesoins.length;
    completedSessions = child.scheduleSesoins
        .where((session) => session['completed'] == true)
        .length;

    // Handle edge case of zero sessions
    final double progressValue = totalSessions > 0
        ? completedSessions / totalSessions
        : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "التقدم الحالي",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '$completedSessions من $totalSessions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue,
                  minHeight: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progressValue * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              if (progressValue >= 1.0)
                const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "مكتمل",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Show AI results button when progress is 100%
          if (progressValue >= 1.0) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showAIResults(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.analytics),
              label: const Text(
                "اظهار نتائج التحليل",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  void _showAIResults(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Prepare session data for AI analysis
      final List<Map<String, dynamic>> sessionsData = child.scheduleSesoins
          .where((session) => session['completed'] == true)
          .map((session) => {
        "session": session["session"],
        "date": session["date"],
        "goals": session["goals"],
        "rate": session["rate"],
        "notes": session["notes"],
        "tasks": session["tasks"],
      })
          .toList();

      // Format data for Gemini API
      final String prompt = """
    قم بتحليل بيانات الجلسات العلاجية التالية واستخرج النتائج النهائية للفترة بالكامل، مع تقديم توصيات للآباء حول كيفية تحسين دعم الطفل في المستقبل. يشمل التحليل:
    1. الأنماط العامة للتقدم خلال الفترة
    2. تحقيق الأهداف وتقييم مستوى الإنجاز
    3. نقاط القوة التي يجب تعزيزها
    4. المجالات التي تحتاج إلى تحسين والتركيز عليها
    5. توصيات مخصصة للآباء لمساعدة الطفل في المرحلة القادمة

    بيانات الجلسات:
    ${jsonEncode(sessionsData)}
    """;

      // Call Gemini API (implementation depends on your Gemini integration)
      final String aiAnalysis = await callGeminiAPI(prompt);

      // Close loading dialog
      Navigator.pop(context);

      // Navigate to results screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AIResultsScreen(
            analysis: aiAnalysis,
            sessionsData: sessionsData,
          ),
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Future<String> callGeminiAPI(String prompt) async {
    final gemini = Gemini.instance;
    int retryCount = 0;
    const maxRetries = 3;
    const baseDelay = 2000; // 2 seconds

    while (retryCount < maxRetries) {
      try {
        // Make API request with timeout
        final response = await gemini.prompt(parts: [Part.text(prompt)]).timeout(
          const Duration(seconds: 130),
          onTimeout: () =>
          throw TimeoutException('Gemini API request timed out'),
        );

        if (response == null ||
            response.output == null ||
            response.output!.isEmpty) {
          throw Exception('Empty response from Gemini API');
        }

        // Return the raw output text
        return response.output!;

      } on Exception catch (e) {
        final errorMessage = e.toString().toLowerCase();

        print('Gemini API error: $errorMessage');

        // Check specifically for rate limit errors (429)
        if (errorMessage.contains('429') ||
            errorMessage.contains('too many requests')) {
          retryCount++;
          if (retryCount >= maxRetries) {
            _logError(
                'Rate limit exceeded', 'Max retries reached after 429 error');
            throw Exception('معدل الطلبات تجاوز الحد المسموح. الرجاء المحاولة لاحقاً.');
          }

          // Exponential backoff with jitter
          final delay = baseDelay * pow(2, retryCount) + Random().nextInt(1000);
          _logError('Rate limit',
              'Received 429 error, retrying in ${delay}ms (attempt $retryCount of $maxRetries)');

          await Future.delayed(Duration(milliseconds: delay.toInt()));
          continue; // Retry the request
        }

        // Handle other errors
        if (e is TimeoutException) {
          _logError('API timeout', e);
          throw Exception('انتهت مدة الاتصال. الرجاء المحاولة مرة أخرى.');
        } else if (errorMessage.contains('400')) {
          _logError('Bad request', e);
          throw Exception('طلب غير صالح إلى واجهة Gemini. تحقق من مفتاح API والمحتوى المرسل.');
        } else {
          _logError('Unexpected error', e);
          throw Exception('حدث خطأ أثناء تحليل البيانات: ${e.toString()}');
        }
      }
    }

    // This should not be reached due to the retry logic, but added as a fallback
    throw Exception('فشل في تحليل البيانات بعد عدة محاولات.');
  }

  void _logError(String type, dynamic error) {
  }

}


// AI Results Screen
class AIResultsScreen extends StatelessWidget {
  final String analysis;
  final List<Map<String, dynamic>> sessionsData;

  const AIResultsScreen({
    super.key,
    required this.analysis,
    required this.sessionsData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تحليل النتائج"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          "تحليل ذكاء اصطناعي",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "تم تحليل ${sessionsData.length} جلسات مكتملة",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "هذا التحليل يقدم نظرة عامة على التقدم والإنجازات والتوصيات بناءً على بيانات الجلسات المكتملة.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // AI Analysis results
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "نتائج التحليل",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Markdown view of analysis
                    MarkdownBody(
                      data: analysis,
                      styleSheet: MarkdownStyleSheet(
                        h2: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        h3: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        p: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Export and share buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Export functionality
                    },
                    icon: const Icon(Icons.download),
                    label: const Text("تصدير التقرير"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Share functionality
                    },
                    icon: const Icon(Icons.share),
                    label: const Text("مشاركة"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}