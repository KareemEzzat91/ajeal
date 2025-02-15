class Goal {
  final String goalName;
  final String goalDescription;
  final List<Task> tasks; // قائمة المهام المرتبطة بالهدف
  final List<Map<String, dynamic>> sessions;
  final List<Map<String, dynamic>> evaluations;
  final List<double> progressData;

  Goal({
    required this.goalName,
    required this.goalDescription,
    required this.tasks,
    required this.sessions,
    required this.evaluations,
    required this.progressData,
  });

  factory Goal.fromMap(Map<String, dynamic> data) {
    return Goal(
      goalName: data['goalName'] ?? '',
      goalDescription: data['goalDescription'] ?? '',
      tasks: (data['tasks'] as List?)?.map((task) => Task.fromMap(task)).toList() ?? [],
      sessions: (data['sessions'] as List?)?.map((session) => Map<String, dynamic>.from(session)).toList() ?? [],
      evaluations: (data['evaluations'] as List?)?.map((evaluation) => Map<String, dynamic>.from(evaluation)).toList() ?? [],
      progressData: (data['progressData'] as List?)?.map((progress) => (progress as num).toDouble()).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goalName': goalName,
      'goalDescription': goalDescription,
      'tasks': tasks.map((task) => task.toMap()).toList(),
      'sessions': sessions,
      'evaluations': evaluations,
      'progressData': progressData,
    };
  }
}

class Task {
  final String taskName;
  final String taskDescription;
  final String goalName;
   double rate; // تقييم المهمة
   String notes; // ملاحظات المهمة

  Task({
    required this.taskName,
    required this.taskDescription,
    required this.goalName,
    this.rate = 0, // قيمة افتراضية للتقييم
    this.notes = "", // قيمة افتراضية للملاحظات
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      taskName: data['taskName'] ?? '',
      taskDescription: data['taskDescription'] ?? '',
      goalName: data['goalName'] ?? '',
      rate: data['rate'] ?? 0, // تحميل التقييم من البيانات
      notes: data['notes'] ?? "", // تحميل الملاحظات من البيانات
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'taskDescription': taskDescription,
      'goalName': goalName,
      'rate': rate, // حفظ التقييم
      'notes': notes, // حفظ الملاحظات
    };
  }

}
