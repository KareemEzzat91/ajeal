import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'add_child_state.dart';

class AddChildCubit extends Cubit<AddChildState> {
  AddChildCubit() : super(AddChildInitial());
    static int id =0;
  final List<Goals> selectedGoals = []; // لتخزين الأهداف المختارة
  List <Child> Children =[];

  void saveChild(String name, String age, DateTime dateOfBirth, String parentOccupation, String notes,context) {
    emit(AddLoadingState());
    final newChild = Child(
      id: id++,
      name: name,
      age: age,
      dateOfBirth: dateOfBirth,
      parentOccupation: parentOccupation,
      notes: notes,
      selectedGoals: selectedGoals,

    );

    Children.add(newChild);
    Navigator.pop(context);
    emit(AddScuccesState());
  }

  void AddChild(Goals goal,context ){
    emit(AddLoadingState());

    if (selectedGoals.length>=10)
     {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(
             'لقد تخطيت الحد المخصص للاهداف لايمكنك اضافة المزيد',
             style: TextStyle(color: Colors.blue[400]),
           ),
         ),
       );

     }
     else {
       selectedGoals.add(goal);

     }
     emit(AddScuccesState());


  }

}
class Child {
  int id ;
  String name;
  String age;
  DateTime dateOfBirth;
  String parentOccupation;
  String notes;
  List<Goals> selectedGoals; // New field to store selected goals

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.dateOfBirth,
    required this.parentOccupation,
    required this.notes,
    this.selectedGoals = const [], // Default empty list
  });
}
