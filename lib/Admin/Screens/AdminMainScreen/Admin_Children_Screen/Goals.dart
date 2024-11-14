
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
      goalName: data['goalName'],
      goalDescription: data['goalDescription'],
      sessions: List<Map<String, dynamic>>.from(data['sessions']),
      evaluations: List<Map<String, dynamic>>.from(data['evaluations']),
      progressData: List<double>.from(data['progressData']),
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
