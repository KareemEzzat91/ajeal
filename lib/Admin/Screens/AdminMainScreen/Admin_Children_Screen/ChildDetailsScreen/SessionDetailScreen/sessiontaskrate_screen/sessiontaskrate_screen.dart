import 'package:flutter/material.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';

class SessionTaskRateScreen extends StatefulWidget {
  final Task task;

  const SessionTaskRateScreen({super.key, required this.task});

  @override
  State<SessionTaskRateScreen> createState() => _SessionTaskRateScreenState();
}

class _SessionTaskRateScreenState extends State<SessionTaskRateScreen> {
  double _rating = 0.0; // تقييم المهمة
  final TextEditingController _notesController = TextEditingController(); // ملاحظات المهمة

  @override
  void initState() {
    super.initState();
    // تعيين القيم هنا بدلاً من build
    _notesController.text = widget.task.notes;
    _rating = widget.task.rate;
  }

  void _saveTaskDetails() {
    // يمكنك هنا حفظ التقييم والملاحظات
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تم الحفظ"),
        content: Text(
          "التقييم: $_rating\nالملاحظات: ${_notesController.text}",
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.task.rate = _rating;
              widget.task.notes = _notesController.text;

              Navigator.pop(context, widget.task);
            },
            child: const Text("حسنًا"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تقييم المهمة",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان المهمة
              Text(
                widget.task.taskName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),

              // وصف المهمة
              Text(
                widget.task.taskDescription,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // تقييم المهمة
              const Text(
                "تقييم المهمة:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Slider(
                value: _rating,
                min: 0,
                max: 10,
                divisions: 10,
                label: _rating.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.grey[300],
              ),
              const SizedBox(height: 20),

              // ملاحظات المهمة
              const Text(
                "ملاحظات المهمة:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _notesController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "أدخل ملاحظاتك هنا...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),

              // زر الحفظ
              Center(
                child: ElevatedButton(
                  onPressed: _saveTaskDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "حفظ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}