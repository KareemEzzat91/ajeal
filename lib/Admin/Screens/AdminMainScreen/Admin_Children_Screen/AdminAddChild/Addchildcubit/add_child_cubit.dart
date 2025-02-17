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
  final Map<String, List<Goal>> selectedGoals = {}; // لتخزين الأهداف المختارة //id == ParentsPhone
  List<Map<String, Child>> Children = []; // id =  ParentsPhone+ id
  List<Map<String, dynamic>> scheduleSesoins = [];

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

  Future<List<Map<String, Child>>>? getAllDataFromFirestore() async {
     Children = []; // id =  ParentsPhone+ id

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User is not authenticated.");
      return [];
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
          final child = Child.fromJson(childDoc.data());
            Children.add({"parentOccupation": child}); // Add the child with a key

        }

        return Children;
      } else {
        print("No document found for user.");
      }
      return[];
    } catch (e) {
      print("Error retrieving data: $e");
      return [];
    }
  }


  void saveChild(String name, String age, DateTime dateOfBirth,
      DateTime startDate, DateTime endDate, String period,
      String parentOccupation, String notes, context) async {
    emit(AddLoadingState());

try {
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
  final userid= FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance.collection("users").doc(userid).collection("children").
  doc('$parentOccupation$id').set(newChild.toMap());
  saveToFirestore();



  Navigator.pop(context);
  emit(AddScuccesState());
}catch(e){
  emit(AddFailureState(e.toString()));
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  Navigator.pop(context);


}
    // دعوة الدالة لإنشاء الجدول الزمني

  }

  void AddGoal(Goal goal, String childId, BuildContext context) {
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
      List<Goal> goalsList,
      ) async {
    final List<String> goals = [];
    final List<String> goalsDescription = [];

    for (var goal in goalsList) {
      goals.add(goal.goalName);
      goalsDescription.add(goal.goalDescription);
    }

    final durationInDays = endDate.difference(startDate).inDays;
  //  final sessionsPerWeek = 3; // عدد الجلسات الأسبوعية

    
    final prompt = """Create a detailed schedule for therapy sessions lasting **$durationInDays days** for the child **$childName**. The schedule should include the following goals:

1. **أهداف تنمية الذاكرة السمعية** (Auditory Memory Development)
2. **أهداف تنمية الذاكرة البصرية** (Visual Memory Development)
3. **أهداف تنمية الكتابة** (Writing Development)
4. **أهداف تنمية القراءة** (Reading Development)
5. **أهداف تنمية الحساب** (Math Development)
6. **أهداف تنمية الإدراك** (Perception Development)
7. **أهداف تنمية الانتباه** (Attention Development)

**Requirements:**
1. The schedule should cover the period from **${startDate.toIso8601String()}** to **${endDate.toIso8601String()}**.
2. There should be **3 sessions per week**, with each session occurring every **3 days**.
3. Distribute the goals evenly across the sessions, ensuring that each goal is addressed multiple times throughout the schedule.
4. Use the **exact names of the goals** as provided above.
5. Return the schedule in **JSON format** with the following structure:

```json
{
  "weeks": [
    {
      "session": 1,
      "date": "YYYY-MM-DD",
      "goals": ["هدف 1", "هدف 2"]
    },
    {
      "session": 2,
      "date": "YYYY-MM-DD",
      "goals": ["هدف 3", "هدف 4"]
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
              'rate':0,
              "notes":"",
              "tasks" :[],

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

  void saveTask(){

  }
  }

