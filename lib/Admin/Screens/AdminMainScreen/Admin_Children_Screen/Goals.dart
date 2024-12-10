
class Goals {
  final String goalName;
  final String goalDescription;
  final List<Map<String, dynamic>> sessions;
  final List<Map<String, dynamic>> evaluations;
  final List<double> progressData;

  Goals({
    required this.goalName,
    required this.goalDescription,
    required this.sessions,
    required this.evaluations,
    required this.progressData,
  });

  // Factory constructor to create a Goals object from a Map
  factory Goals.fromMap(Map<String, dynamic> data) {
    return Goals(
      goalName: data['goalName'] ?? '',
      goalDescription: data['goalDescription'] ?? '',
      sessions: (data['sessions'] as List?)?.map((session) => Map<String, dynamic>.from(session)).toList() ?? [],
      evaluations: (data['evaluations'] as List?)?.map((evaluation) => Map<String, dynamic>.from(evaluation)).toList() ?? [], // Default to an empty list if 'evaluations' is null
      progressData: (data['progressData'] as List?)?.map((progress) => (progress as num).toDouble()).toList() ?? [], // Default to an empty list if 'progressData' is null
    );
  }

  // Method to convert a Goals object back to a Map
  Map<String, dynamic> toMap() {
    return {
      'goalName': goalName,
      'goalDescription': goalDescription,
      'sessions': sessions,
      'evaluations': evaluations,
      'progressData': progressData,
    };
  }
}
