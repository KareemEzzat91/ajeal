import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/SessionDetailScreen/choosetasks_screen/choosetasks_screen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/SessionDetailScreen/sessiontaskrate_screen/sessiontaskrate_screen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/goal_lists/goal_lists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SessionDetailScreen extends StatefulWidget {
  final String childId;
  final int sessionName;
  final String date;
  final List<String> goals;
  final num rate;
  final String notes;
  final List tasks;

  const SessionDetailScreen({
    Key? key,
    required this.sessionName,
    required this.date,
    required this.goals,
    required this.childId, required this.rate, required this.notes, required this.tasks,
  }) : super(key: key);

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final TextEditingController _notesController = TextEditingController();
  double _rating = 0.0;
  List<List<Task>> _selectedTasksPerGoal = [];
  @override
  void initState() {
    super.initState();
    _rating = widget.rate.toDouble();
    _notesController.text = widget.notes;

    // Initialize _selectedTasksPerGoal with tasks from the session
    _selectedTasksPerGoal = List.generate(widget.goals.length, (_) => []);

    // Convert widget.tasks into List<List<Task>>
    if (widget.tasks.isNotEmpty) {
      for (var taskMap in widget.tasks) {
        final task = Task.fromMap(taskMap);
        final goalIndex = widget.goals.indexOf(task.goalName);
        if (goalIndex != -1) {
          _selectedTasksPerGoal[goalIndex].add(task);
        }
      }
    }
  }  Goal getGoal(String goalName) {
    return Goals_Lists.goalList.firstWhere(
          (goal) => goal.goalName == ( goalName), // استخدام التعبير 'اهداف ' + goalName
      orElse: () =>throw("Error"), // هدف افتراضي إذا لم يتم العثور
    );
  }

  void _saveSessionDetails() async {
    final notes = _notesController.text;

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("children")
          .doc(widget.childId)
          .get();

      if (userSnapshot.exists) {
        final tasksData = _selectedTasksPerGoal
            .expand((tasks) => tasks)
            .map((task) => task.toMap())
            .toList();

        final sessionData = {
          "session": widget.sessionName,
          "date":widget.date,
          "goals": widget.goals,
          'rate': _rating,
          'notes': notes,
          'tasks': tasksData,
        };

        // استرجاع القائمة الحالية
        final currentScheduleSesoins = List<Map<String, dynamic>>.from(userSnapshot.data()!['scheduleSesoins'] ?? []);

        // تحديث الجلسة المحددة
        if (widget.sessionName - 1 < currentScheduleSesoins.length) {
          currentScheduleSesoins[widget.sessionName - 1] = sessionData;
        } else {
          // إذا كانت الجلسة غير موجودة، أضفها كجلسة جديدة
          currentScheduleSesoins.add(sessionData);
        }

        // حفظ التغييرات في Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection("children")
            .doc(widget.childId)
            .update({
          'scheduleSesoins': currentScheduleSesoins,
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("تم الحفظ"),
            content: Text(
              "التقييم: $_rating\nالملاحظات: $notes\nالمهام المختارة: ${_selectedTasksPerGoal.map((tasks) => tasks.map((task) => task.taskName).join(", ")).join("; ")}",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("حسنًا"),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("خطأ"),
            content: const Text("لم يتم العثور على بيانات الطفل."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("حسنًا"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("خطأ"),
          content: Text("حدث خطأ أثناء الحفظ: $e"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("حسنًا"),
            ),
          ],
        ),
      );
    }
  }
  Widget _buildGoalItem(int goalIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "- ${widget.goals[goalIndex]}",
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  final thisGoal = getGoal(widget.goals[goalIndex]);
                  final selectedTasks = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseTasksScreen(selectedGoal: thisGoal),
                    ),
                  );
                  if (selectedTasks != null) {
                    setState(() {
                      _selectedTasksPerGoal[goalIndex] = selectedTasks;
                    });
                  }
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const Text(
            "المهام المختارة:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedTasksPerGoal[goalIndex].length,
            itemBuilder: (context, taskIndex) {
              return GestureDetector(
                onTap: () async {
                  final updatedTask = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SessionTaskRateScreen(
                        task: _selectedTasksPerGoal[goalIndex][taskIndex],
                      ),
                    ),
                  );
                  if (updatedTask != null) {
                    setState(() {
                      _selectedTasksPerGoal[goalIndex][taskIndex] = updatedTask;
                    });
                  }
                },                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ListTile(
                    trailing: Column(
                      children: [
                        Text("Rate: ${_selectedTasksPerGoal[goalIndex][taskIndex].rate}"),
                        Icon(
                          Icons.star,
                          color: _selectedTasksPerGoal[goalIndex][taskIndex].rate != 0 ? Colors.yellow : Colors.black,
                        ),
                      ],
                    ),
                    title: Text(
                      _selectedTasksPerGoal[goalIndex][taskIndex].taskName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      _selectedTasksPerGoal[goalIndex][taskIndex].taskDescription,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تفاصيل الجلسة: ${widget.sessionName}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              "اسم الجلسة: ${widget.sessionName}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "التاريخ: ${widget.date}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              "الأهداف:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.goals.length,
              itemBuilder: (context, goalIndex) => _buildGoalItem(goalIndex),
            ),
            const SizedBox(height: 20),
            const Text(
              "تقييم الطفل:",
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
            ),
            const SizedBox(height: 20),
            const Text(
              "ملاحظات عن الجلسة:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "أدخل ملاحظاتك هنا...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveSessionDetails,
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
    );
  }
}