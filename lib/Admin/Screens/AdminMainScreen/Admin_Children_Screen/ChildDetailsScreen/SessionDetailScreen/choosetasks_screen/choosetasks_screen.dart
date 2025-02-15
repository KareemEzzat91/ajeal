import 'package:flutter/material.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';

class ChooseTasksScreen extends StatefulWidget {
  final Goal selectedGoal;

  const ChooseTasksScreen({super.key, required this.selectedGoal});

  @override
  State<ChooseTasksScreen> createState() => _ChooseTasksScreenState();
}

class _ChooseTasksScreenState extends State<ChooseTasksScreen> {
  List<Task> _selectedTasks = []; // قائمة المهام المختارة

  void _toggleTaskSelection(Task task) {
    setState(() {
      if (_selectedTasks.contains(task)) {
        _selectedTasks.remove(task); // إزالة المهمة إذا كانت مختارة بالفعل
      } else {
        _selectedTasks.add(task); // إضافة المهمة إذا لم تكن مختارة
      }
    });
  }

  void _saveSelectedTasks() {
    // يمكنك هنا حفظ المهام المختارة أو إعادتها إلى الشاشة السابقة
    Navigator.pop(context, _selectedTasks); // إرجاع المهام المختارة إلى الشاشة السابقة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "اختر المهام: ${widget.selectedGoal.goalName}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedGoal.tasks.length,
                itemBuilder: (context, index) {
                  final task = widget.selectedGoal.tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Checkbox(
                        value: _selectedTasks.contains(task),
                        onChanged: (value) {
                          _toggleTaskSelection(task);
                        },
                        activeColor: Colors.blueAccent,
                      ),
                      title: Text(
                        task.taskName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        task.taskDescription,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.task, color: Colors.blueAccent),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSelectedTasks,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "حفظ المهام المختارة",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}