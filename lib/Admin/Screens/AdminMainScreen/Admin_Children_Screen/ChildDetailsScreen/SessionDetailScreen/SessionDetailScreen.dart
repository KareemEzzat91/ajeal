import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/SessionDetailScreen/choosetasks_screen/choosetasks_screen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/SessionDetailScreen/sessiontaskrate_screen/sessiontaskrate_screen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/goal_lists/goal_lists.dart';
import 'package:ajeal/Admin/models/goals_model/Goals.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionDetailScreen extends StatefulWidget {
  final String childId;
  final int sessionName;
  final String date;
  final List<String> goals;
  final num rate;
  final String notes;
  final List tasks;
  final bool isParent;
  final String childName ;
  final bool ? isOthers ;
  final String ?doctorId;
  final int? completedSessions;
  final bool isCompleted;

  const SessionDetailScreen({
    super.key,
    required this.sessionName,
    required this.childName,
    required this.date,
    required this.goals,
    required this.childId,
    required this.rate,
    required this.notes,
    required this.tasks,
    required this.isParent,
    required this.isCompleted,
     this.isOthers,
     this.doctorId,
     this.completedSessions,
  });

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final TextEditingController _notesController = TextEditingController();
  double _rating = 0.0;
  List<List<Task>> _selectedTasksPerGoal = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _rating = widget.rate.toDouble();
    _notesController.text = widget.notes;
    _selectedTasksPerGoal = List.generate(widget.goals.length, (_) => []);

    if (widget.tasks.isNotEmpty) {
      for (var taskMap in widget.tasks) {
        final task = Task.fromMap(taskMap);
        final goalIndex = widget.goals.indexOf(task.goalName);
        if (goalIndex != -1) {
          _selectedTasksPerGoal[goalIndex].add(task);
        }
      }
    }
  }

  Goal getGoal(String goalName) {
    return Goals_Lists.goalList.firstWhere(
      (goal) => goal.goalName == goalName,
      orElse: () => throw ("Error"),
    );
  }

  Future<void>
  _saveSessionDetails() async {
    setState(() => _isSaving = true);

    try {
      final String uid ;

      if (widget.isOthers! &&widget.isOthers!=null){
    final  doctorSnap = await FirebaseFirestore.instance.collection("Doctors").doc(widget.doctorId).get();
    uid =doctorSnap["Doctor_id"];

      }else {
        uid = FirebaseAuth.instance.currentUser!.uid;
      }

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("children")
          .doc(widget.childId);

      final userSnapshot = await userRef.get();
      if (!userSnapshot.exists) {
        _showErrorDialog("لم يتم العثور على بيانات الطفل.");
        return;
      }

      final tasksData = _selectedTasksPerGoal
          .expand((tasks) => tasks)
          .map((task) => task.toMap())
          .toList();


      final sessionData = {
        "session": widget.sessionName,
        "date": widget.date,
        "goals": widget.goals,
        'rate': _rating,
        'notes': _notesController.text,
        'tasks': tasksData,
        "completed":true
      };

      final currentScheduleSesoins = List<Map<String, dynamic>>.from(
          userSnapshot.data()!['scheduleSesoins'] ?? []);

      if (widget.sessionName - 1 < currentScheduleSesoins.length) {
        currentScheduleSesoins[widget.sessionName - 1] = sessionData;
      } else {
        currentScheduleSesoins.add(sessionData);
      }
      print(widget.completedSessions);
       final cmp= widget.isCompleted?widget.completedSessions:widget.completedSessions!+1;
      print(cmp);
      await userRef.update({'scheduleSesoins': currentScheduleSesoins,"completedSessions":cmp});
      await FirebaseFirestore.instance.collection("Children").doc(widget.childId).update({'scheduleSesoins': currentScheduleSesoins,"completedSessions":cmp});
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog("حدث خطأ أثناء الحفظ: $e");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title:

     const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text("تم الحفظ بنجاح   "),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("التقييم: $_rating"),
            const SizedBox(height: 8),
            Text("الملاحظات: ${_notesController.text}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("حسنًا"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 10),
            Text("خطأ"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("حسنًا"),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  "${S.of(context).session} ${widget.sessionName}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                const SizedBox(width: 10),
                Text(
                  widget.date,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(int goalIndex) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        title: Text(
          widget.goals[goalIndex],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.flag, color: Colors.blue),
        trailing: BlocBuilder<AddChildCubit, AddChildState>(
  builder: (context, state) {
    
    return IconButton(
          icon: const Icon(Icons.add_task),
          onPressed: () { context.read<AddChildCubit>().updateUserInfo(isOthers: widget.isOthers??false,key: "taskAddedFor", value: widget.childName)   ;_addTasksToGoal(goalIndex);}
        );
  },
),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedTasksPerGoal[goalIndex].isEmpty)
                  const Center(
                    child: Text(
                      "لا توجد مهام مختارة",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedTasksPerGoal[goalIndex].length,
                    itemBuilder: (context, taskIndex) =>
                        _buildTaskItem(goalIndex, taskIndex),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(int goalIndex, int taskIndex) {
    final task = _selectedTasksPerGoal[goalIndex][taskIndex];
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: () => _editTaskRate(goalIndex, taskIndex),
        title: Text(
          task.taskName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(task.taskDescription),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${S.of(context).successRate}: ${task.rate}",
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.star,
              color: task.rate != 0 ? Colors.amber : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addTasksToGoal(int goalIndex) async {
    
    final thisGoal = getGoal(widget.goals[goalIndex]);
    final selectedTasks = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseTasksScreen(selectedGoal: thisGoal),
      ),
    );
    if (selectedTasks != null) {
      setState(() => _selectedTasksPerGoal[goalIndex] = selectedTasks);
    }
  }

  Future<void> _editTaskRate(int goalIndex, int taskIndex) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionTaskRateScreen(
          isParent: widget.isParent,
          task: _selectedTasksPerGoal[goalIndex][taskIndex],
        ),
      ),
    );
    if (updatedTask != null) {
      setState(() => _selectedTasksPerGoal[goalIndex][taskIndex] = updatedTask);
    }
  }

  Widget _buildRatingSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              S.of(context).childRate,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _rating,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _rating.toStringAsFixed(1),
                    onChanged: (value) => setState(() => _rating = value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              S.of(context).sessionNote,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "أدخل ملاحظاتك هنا...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => AddChildCubit(),
  child: Builder(
    builder: (context) {
      final bloc = context.read<AddChildCubit>();
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "${S.of(context).details } ${S.of(context).session} ${widget.sessionName}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue[700],
          ),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  ...List.generate(
                    widget.goals.length,
                    (index) => _buildGoalItem(index),
                  ),
                  const SizedBox(height: 16),
                  _buildRatingSection(),
                  const SizedBox(height: 16),
                  _buildNotesSection(),
                  const SizedBox(height: 80),
                ],
              ),
              widget.isParent
                  ? const SizedBox()
                  : Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : (){_saveSessionDetails();bloc.updateUserInfo(isOthers: widget.isOthers??false ,key: "lastSessionWith", value:widget.childName); },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(color: Colors.white)
                            :  Text(
                                S.of(context).saveChildInformation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
            ],
          ),
        );
    }
  ),
);
  }
}
