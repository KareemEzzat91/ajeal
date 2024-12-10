import 'dart:convert';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildModel/ChildModel.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

part 'add_child_state.dart';

class AddChildCubit extends Cubit<AddChildState> {
  AddChildCubit() : super(AddChildInitial());
  static int id = 0;
  final Map<String, List<Goals>> selectedGoals = {}; // لتخزين الأهداف المختارة //id == ParentsPhone
  List<Map<String, Child>> Children = []; // id =  ParentsPhone+ id
  void saveToFirestore()async {
    emit(AddLoadingState());
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User not logged in");
      return;
    }
    final userDoc = FirebaseFirestore.instance.collection("users").doc(userId);
    for (var childMap in Children) {
      await Future.forEach(childMap.entries, (MapEntry<String, Child> childEntry) async {
        await userDoc.collection("children").doc(childEntry.key).set(childEntry.value.toMap());
      });
    }
    // حفظ الـ ID
    userDoc.set({"lastChildId": id}, SetOptions(merge: true));
    print("Data saved successfully!");
    emit(AddScuccesState());
  }

  void getAllDataFromFirestore() async {
     final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User is not authenticated.");
      return;
    }

    try {
       final userDoc = await FirebaseFirestore.instance.collection("users").doc(userId).get();

      if (userDoc.exists) {
        print("User Data: ${userDoc.data()}");

        // جلب جميع الوثائق في مجموعة الأطفال (children)
        final childrenSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("children")
            .get();

        for (var childDoc in childrenSnapshot.docs) {
          print("Child Data: ${childDoc.data()}");

          // إذا كان هناك مجموعات فرعية إضافية لكل طفل
          final goalsSnapshot = await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("children")
              .doc(childDoc.id)
              .collection("goals")
              .get();

          for (var goalDoc in goalsSnapshot.docs) {
            print("Goal Data for child ${childDoc.id}: ${goalDoc.data()}");
          }
        }
      } else {
        print("No document found for user.");
      }
    } catch (e) {
      print("Error retrieving data: $e");
    }
  }

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
  Distribute the goals across the weekly sessions, considering the number of sessions per week (3 weekly sessions session every three days ). Please return the schedule in JSON format with the following structure:
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
      String rawResponse = response?.output ?? '';

      // Clean the response
      rawResponse = rawResponse.trim();
      if (rawResponse.startsWith('```json')) {
        rawResponse = rawResponse.replaceFirst('```json', '');
      }
      if (rawResponse.endsWith('```')) {
        rawResponse = rawResponse.substring(0, rawResponse.lastIndexOf('```'));
      }

      // Parse the cleaned response
      final List<Map<String, dynamic>> sessionsList = [];
      final jsonResponse = jsonDecode(rawResponse);

      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('weeks')) {
        final weeks = jsonResponse['weeks'] as List<dynamic>;
        for (int i = 0; i < weeks.length; i++) {
          final week = weeks[i];
          if (week is Map<String, dynamic>) {
            sessionsList.add({
              "session": week['session'],
              "date": week['date'],
              "goals": List<String>.from(week['goals']),
            });
          } else {
            print("Invalid week format: $week");
          }
        }
      } else {
        print("Invalid response format or missing 'weeks' key");
      }

      return sessionsList;
    } catch (e) {
      throw Exception("Error generating schedule: $e");
    }
  }

  }

