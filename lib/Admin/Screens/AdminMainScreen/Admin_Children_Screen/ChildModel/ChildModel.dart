import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';

class Child {
  int id;
  String name;
  String age;
  DateTime dateOfBirth;
  DateTime startDate;
  DateTime endDate;
  String period;
  String parentOccupation;
  String notes;
  List<Goals> selectedGoals;
  List<Map<String, dynamic>> scheduleSesoins;

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.dateOfBirth,
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.parentOccupation,
    required this.notes,
    required this.selectedGoals,
    required this.scheduleSesoins,
  });

  // تحويل الـ Child إلى Map لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'period': period,
      'parentOccupation': parentOccupation,
      'notes': notes,
      'goals': selectedGoals.map((goal) => goal.toMap()).toList(),
      'scheduleSesoins': scheduleSesoins,
    };
  }
  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      period: json['period'],
      parentOccupation: json['parentOccupation'],
      notes: json['notes'],
      selectedGoals: (json['goals'] as List?)?.map((goal) => Goals.fromMap(Map<String, dynamic>.from(goal))).toList() ?? [],
      scheduleSesoins: (json['scheduleSesoins'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [], // If 'scheduleSesoins' is null, use an empty list
    );
  }

}
