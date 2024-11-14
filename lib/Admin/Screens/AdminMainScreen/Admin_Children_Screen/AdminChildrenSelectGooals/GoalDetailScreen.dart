import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:flutter/material.dart';

class GoalDetailScreen extends StatelessWidget {
  final Goals goal;

  const GoalDetailScreen({
    super.key,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل الهدف: ${goal.goalName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.goalName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                goal.goalDescription,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Section: Session Scheduling
              const Text(
                "جدولة الجلسات:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...goal.sessions.map((session) {
                return ListTile(
                  title: Text("جلسة بتاريخ ${session['date']}"),
                  subtitle: Text("الأهداف الموزعة: ${session['objectives']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Code to edit scheduled session
                    },
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),

              // Section: Evaluation Sessions
              const Text(
                "جلسات التقييم:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...goal.evaluations.map((evaluation) {
                return ListTile(
                  title: Text("جلسة بتاريخ ${evaluation['date']}"),
                  subtitle: Text("التقييم: ${evaluation['rating']}"),
                  trailing: Text(
                    "ملاحظات: ${evaluation['notes']}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),

              // Section: Progress Chart
              const Text(
                "التقدم:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                child: CustomPaint(
                  painter: ProgressChartPainter(goal.progressData),
                ),
              ),
              const SizedBox(height: 20),

              // Section: Notes on Strengths and Weaknesses
              const Text(
                "ملاحظات:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "نقاط القوة: ...",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                "نقاط الضعف: ...",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomPaint component for drawing the progress chart
class ProgressChartPainter extends CustomPainter {
  final List<double> progressData;
  ProgressChartPainter(this.progressData);

  @override
  void paint(Canvas canvas, Size size) {
    // Code to draw the progress chart based on progressData
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
