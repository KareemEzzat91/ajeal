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
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goal Title
              Text(
                goal.goalName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),

              // Goal Description
              Text(
                goal.goalDescription,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Section: Session Scheduling
              _buildSectionTitle("جدولة الجلسات:"),
              ...goal.sessions.map((session) {
                return _buildSessionTile(context, session);
              }).toList(),
              const SizedBox(height: 20),

              // Section: Evaluation Sessions
              _buildSectionTitle("جلسات التقييم:"),
              ...goal.evaluations.map((evaluation) {
                return _buildEvaluationTile(context, evaluation);
              }).toList(),
              const SizedBox(height: 20),

              // Section: Progress Chart
              _buildSectionTitle("التقدم:"),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: CustomPaint(
                  painter: ProgressChartPainter(goal.progressData),
                ),
              ),
              const SizedBox(height: 20),

              // Section: Notes on Strengths and Weaknesses
              _buildSectionTitle("ملاحظات:"),
              _buildNotes("نقاط القوة: ...", Colors.green),
              const SizedBox(height: 5),
              _buildNotes("نقاط الضعف: ...", Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Session Tile Widget with edit functionality
  Widget _buildSessionTile(BuildContext context, Map session) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text("جلسة بتاريخ ${session['date']}"),
        subtitle: Text("الأهداف الموزعة: ${session['objectives']}"),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            _editSession(context, session);
          },
        ),
      ),
    );
  }

  // Evaluation Tile Widget
  Widget _buildEvaluationTile(BuildContext context, Map evaluation) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text("جلسة بتاريخ ${evaluation['date']}"),
        subtitle: Text("التقييم: ${evaluation['rating']}"),
        trailing: Text(
          "ملاحظات: ${evaluation['notes']}",
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  // Notes Widget
  Widget _buildNotes(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: color),
      ),
    );
  }

  // Edit Session Functionality (Placeholder)
  void _editSession(BuildContext context, Map session) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("تعديل الجلسة"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: session['date']),
                decoration: InputDecoration(labelText: "التاريخ"),
              ),
              TextField(
                controller: TextEditingController(text: session['objectives']),
                decoration: InputDecoration(labelText: "الأهداف"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                // Save the edited session
                Navigator.pop(context);
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }
}

// CustomPainter component for drawing the progress chart
class ProgressChartPainter extends CustomPainter {
  final List<double> progressData;
  ProgressChartPainter(this.progressData);

  @override
  void paint(Canvas canvas, Size size) {
    // Example drawing: Simple circle representing the progress
    Paint paint = Paint()..color = Colors.blueAccent..style = PaintingStyle.fill;
    double progress = progressData.isNotEmpty ? progressData[0] : 0.0;
    double radius = size.width / 2;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    // More complex chart logic can be added here based on progressData
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
