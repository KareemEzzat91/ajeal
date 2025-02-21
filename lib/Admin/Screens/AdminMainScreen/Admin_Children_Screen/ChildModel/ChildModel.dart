
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
  String school;
  String fatherOccupation;
  String motherOccupation;
  String familyMembers;
  String residence;
  String motherAgeDuringPregnancy;
  String relationshipBetweenParents;
  String familyRelationship;
  String motherNature;
  List<Goal> selectedGoals;
  List<Map<String, dynamic>> scheduleSesoins;
  String doctorId;
  String doctorName;
  List<Map<String, dynamic>> dailyNotes;
  String gender;
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
    required this.school,
    required this.fatherOccupation,
    required this.motherOccupation,
    required this.familyMembers,
    required this.residence,
    required this.motherAgeDuringPregnancy,
    required this.relationshipBetweenParents,
    required this.familyRelationship,
    required this.motherNature,
    required this.selectedGoals,
    required this.scheduleSesoins,
    required this.doctorId,
    required this.doctorName,
    required this.dailyNotes,
    required this.gender,
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
      'school': school,
      'fatherOccupation': fatherOccupation,
      'motherOccupation': motherOccupation,
      'familyMembers': familyMembers,
      'residence': residence,
      'motherAgeDuringPregnancy': motherAgeDuringPregnancy,
      'relationshipBetweenParents': relationshipBetweenParents,
      'familyRelationship': familyRelationship,
      'motherNature': motherNature,
      'goals': selectedGoals.map((goal) => goal.toMap()).toList(),
      'scheduleSesoins': scheduleSesoins,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'dailyNotes': dailyNotes,
      'gender': gender,
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
      school: json['school'],
      fatherOccupation: json['fatherOccupation'],
      motherOccupation: json['motherOccupation'],
      familyMembers: json['familyMembers'],
      residence: json['residence'],
      motherAgeDuringPregnancy: json['motherAgeDuringPregnancy'],
      relationshipBetweenParents: json['relationshipBetweenParents'],
      familyRelationship: json['familyRelationship'],
      motherNature: json['motherNature'],
      selectedGoals: (json['goals'] as List?)?.map((goal) => Goal.fromMap(Map<String, dynamic>.from(goal))).toList() ?? [],
      scheduleSesoins: (json['scheduleSesoins'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      dailyNotes: (json['dailyNotes'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [],
      gender: json['gender'],


    );
  }
}