import 'dart:convert';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

part 'add_child_state.dart';

class AddChildCubit extends Cubit<AddChildState> {
  AddChildCubit() : super(AddChildInitial());
  static int id = 0;
  final Map<String, List<Goals>> selectedGoals = {}; // لتخزين الأهداف المختارة //id == ParentsPhone
  List<Map<String, Child>> Children = []; // id = ParentsPhone + id
  List<Map<String, dynamic>> scheduleSesoins = [];

  void saveChild(String name, String age, DateTime dateOfBirth,
      DateTime startDate, DateTime endDate, String period,
      String parentOccupation, String notes, context) async {
    emit(AddLoadingState());

    // دعوة الدالة لإنشاء الجدول الزمني
    scheduleSesoins = await generateSchedule(startDate, endDate, period, name, selectedGoals[parentOccupation]!);
    print(scheduleSesoins);

    // إنشاء الطفل الجديد
    final newChild = Child(
      id: id++,
      name: name,
      age: age,
      dateOfBirth: dateOfBirth,
      startDate: startDate,
      endDate: endDate,
      period: period,
      parentOccupation: parentOccupation,
      notes: notes,
      scheduleSesoins: scheduleSesoins,
      selectedGoals: selectedGoals[parentOccupation]!,
    );

    Children.add({'$parentOccupation$id': newChild});

    Navigator.pop(context);
    emit(AddScuccesState());
  }

  void AddGoal(Goals goal, String childId, BuildContext context) {
    emit(NumberofItemsPlusstate());
    if (selectedGoals.containsKey(childId)) {
      if (selectedGoals[childId]!.length < 10) {
        selectedGoals[childId]!.add(goal);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You have reached the max limit of 10 goals for this child.',
              style: TextStyle(color: Colors.blue[400]),
            ),
          ),
        );
      }
    } else {
      selectedGoals[childId] = [goal];
    }

  }

  Future<List<Map<String, dynamic>>> generateSchedule(
      DateTime startDate,
      DateTime endDate,
      String duration,
      String childName,
      List<Goals> goalsList,
      ) async {
    final List<String> goals = [];
    final List<String> goalsDescription = [];

    for (var goal in goalsList) {
      goals.add(goal.goalName);
      goalsDescription.add(goal.goalDescription);
    }

    final durationInDays = endDate.difference(startDate).inDays;
    final sessionsPerWeek = 3; // عدد الجلسات الأسبوعية

    final prompt = """
    Create a schedule for sessions lasting $durationInDays days for the child $childName with the following goals: ${goals.join(', ')}.
    Start Date: ${startDate.toIso8601String()}, End Date: ${endDate.toIso8601String()}.
    Distribute the goals across the weekly sessions, considering the number of sessions per week (3 weekly sessions). Please return the schedule in JSON format with the following structure:
    {
      "weeks": [
        {
          "session": 1,
          "date": "2024-01-01",
          "goals": ["${goalsDescription[0]}", "${goalsDescription[0]}"]
        },
        {
          "session": 2,
          "date": "2024-01-03",
          "goals": ["${goalsDescription[0]}", "${goalsDescription[0]}"]
        },
        ...
      ]
    }
    """;

    final gemini = Gemini.instance;

    try {
      final response = await gemini.text(prompt);
      print(response);

      // تحويل الاستجابة إلى JSON
      String scheduleText = response?.output ?? '';
      final jsonResponse = parseScheduleToJson(scheduleText);

      return jsonResponse;
    } catch (e) {
      throw Exception("Error generating schedule: $e");
    }
  }

  // تحليل الاستجابة إلى JSON
  List<Map<String, dynamic>> parseScheduleToJson(String text) {
    final List<Map<String, dynamic>> sessionsList = [];

    try {
      // Debug: Print the raw response to check what is being returned
      print("Raw Response: $text");

      // Ensure that the text starts with { or [
      if (text.trim().isEmpty || (!text.trim().startsWith("{") && !text.trim().startsWith("["))) {
        print("The response is not a valid JSON string.");
        return sessionsList;
      }

      // Try to decode the JSON response
      final jsonResponse = jsonDecode(text); // تحويل النص إلى JSON

      // Check if 'weeks' exists and is a list
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('weeks')) {
        final weeks = jsonResponse['weeks'] as List<dynamic>;

        for (int i = 0; i < weeks.length; i++) {
          final week = weeks[i];

          // Ensure that 'sessions' exists and is a list
          if (week is Map<String, dynamic> && week.containsKey('sessions')) {
            List<Map<String, dynamic>> sessions = [];

            for (var session in week['sessions']) {
              if (session is Map<String, dynamic> && session.containsKey('session') && session.containsKey('date') && session.containsKey('goals')) {
                sessions.add({
                  "session": session['session'],
                  "date": session['date'],
                  "goals": List<String>.from(session['goals']),
                });
              } else {
                print("Invalid session format for week ${i + 1}, session data: $session");
              }
            }

            sessionsList.add({"week${i + 1}": sessions});
          } else {
            print("Invalid or missing sessions for week ${i + 1}");
          }
        }
      } else {
        print("Invalid response format or missing 'weeks' key");
      }
    } catch (e) {
      print("Error parsing schedule: $e");
    }

    return sessionsList;
  }
}

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
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.dateOfBirth,
    required this.parentOccupation,
    required this.scheduleSesoins,
    required this.notes,
    this.selectedGoals = const [], // قائمة الأهداف المحددة
  });
}
