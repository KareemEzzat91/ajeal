import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'add_child_state.dart';

class AddChildCubit extends Cubit<AddChildState> {
  AddChildCubit() : super(AddChildInitial());
  static int id = 0;
  final Map<String, List<Goals>> selectedGoals = {}; // لتخزين الأهداف المختارة//id ==ParentsPhone
  List<Map<String, Child>> Children = [];//id =ParentsPhone+id

  void saveChild(String name, String age, DateTime dateOfBirth,DateTime startDate,DateTime endDate,String period ,
      String parentOccupation, String notes, context) {
    emit(AddLoadingState());
    final newChild = Child(
      id: id++,
      name: name,
      age: age,
      dateOfBirth: dateOfBirth,
      startDate:startDate,
      endDate: endDate,
      period :period,
      parentOccupation: parentOccupation,
      notes: notes,
      selectedGoals: selectedGoals,

    );

    Children.add({parentOccupation +'${id}': newChild});
    Navigator.pop(context);
    emit(AddScuccesState());
  }

  void AddGoal(Goals goal, String childId, BuildContext context) {
    // Emit loading state (for state management, typically with Bloc or Provider)
    emit(AddLoadingState());

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
}
class Child {
  int id ;
  String name;
  String age;
  DateTime dateOfBirth;
  DateTime startDate;
  DateTime endDate;
  String period;
  String parentOccupation;
  String notes;
Map<String,List<Goals>> selectedGoals; // New field to store selected goals

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.dateOfBirth,
    required this.parentOccupation,
    required this.notes,
    this.selectedGoals = const{}, // Default empty list
  });
}
