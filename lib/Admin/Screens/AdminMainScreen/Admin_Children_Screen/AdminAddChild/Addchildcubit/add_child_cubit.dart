import 'dart:async';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/generate.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/sendvreficationmessage.dart';
import 'package:ajeal/Admin/models/ChildModel/ChildModel.dart';
import 'package:ajeal/Admin/models/doctor_model/doctor_model.dart';
import 'package:ajeal/Admin/models/goals_model/Goals.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'add_child_state.dart';

class AddChildCubit extends Cubit<AddChildState> {
  AddChildCubit() : super(AddChildInitial());
  static int id = 0;
  final Map<String, List<Goal>> selectedGoals = {}; // لتخزين الأهداف المختارة //id == ParentsPhone
  List<Map<String, Child>> Children = []; // id =  ParentsPhone+ id
  List<Map<String, dynamic>> scheduleSesoins = [];
  String lastChattedWith ="Mohammed";
  String lastSessionWith = "Mohammed";
  String taskAddedFor = "Mohammed";
  String lastChildName = "Ahmed";

  void saveToFirestore() async {
    emit(AddLoadingState());
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return;
    }
    final userDoc = FirebaseFirestore.instance.collection("users").doc(userId);
    var userdata = await userDoc.get();
    id = userdata["lastChildId"];
    for (var childMap in Children) {
      await Future.forEach(childMap.entries,
          (MapEntry<String, Child> childEntry) async {
        await userDoc
            .collection("children")
            .doc(childEntry.key)
            .set(childEntry.value.toMap());
      });
    }
    // حفظ الـ ID
    userDoc.set({"lastChildId": id}, SetOptions(merge: true));
    emit(AddScuccesState());
  }

   Future <void >updateUserInfo({required String key, required String value})async{
  final uid=  FirebaseAuth.instance.currentUser!.uid;
   await FirebaseFirestore.instance.collection("users").doc(uid).update({
     key:value
   });

   }
   Future<Doctor?>getUserInfo()async{
     final uid=  FirebaseAuth.instance.currentUser!.uid;
     final snapshot= await FirebaseFirestore.instance.collection("users").doc(uid).get();
     if(snapshot.exists)
     {
      return Doctor.fromJson(snapshot.data()??{"Doctor_Name":"",
        "Doctor_id":"",
        "Doctor_phone":"",
        "lastChildId":0,
        "lastChildName":"",
        "lastSessionWith":"",
        "taskAddedFor":"",
        "lastChattedWith":"",
      });
     }
     return  Doctor.fromJson({"Doctor_Name":"",
       "Doctor_id":"",
       "Doctor_phone":"",
       "lastChildId":0,
       "lastChildName":"",
       "lastSessionWith":"",
       "taskAddedFor":"",
     "lastChattedWith":"",
     });

   }
  Future<List<Map<String, Child>>>? getAllDataFromFirestore() async {
    Children = []; // id =  ParentsPhone+ id

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDoc.exists) {

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
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  void saveChild(
    BuildContext context, {
    required String name,
    required String age,
    required DateTime dateOfBirth,
    required DateTime startDate,
    required DateTime endDate,
    required String period,
    required String parentPhone,
    required String notes,
    required String school,
    required String residence,
    required String gender,
    required List<Goal> selectedGoals,
    // Family Information
    required String fatherOccupation,
    required String motherOccupation,
    required String familyMembers,
    required String siblingsInfluence,
    required String siblingCloseness,
    required String motherAge,
    required String parentsRelationship,
    required String familyRelationship,
    required String motherNature,
    // Developmental History - Pregnancy Phase
    required String pregnancyNature,
    required String motherDiseasesDuringPregnancy,
    required String pregnancyComplications,
    required String motherStressDuringPregnancy,
    // Birth Phase
    required String birthType,
    required String birthComplications,
    required String birthTiming,
    // Post-Birth
    required String incubator,
    required String incubatorPeriod,
    required String jaundice,
    required String jaundiceRate,
    // Health History
    required String vaccinations,
    required String measles,
    required String smallpox,
    required String medications,
    // First Year Growth
    required String teething,
    required String babbling,
    required String motherVoiceAttention,
    required String sittingAlone,
    required String crawling,
    required String walking,
    required String handPointing,
    // Psychological History
    required String familyDisabilities,
    // Social History
    required String socialInteraction,
    required String parentAbsence,
    // Medical Examinations
    required String hearing,
    required String vision,
    required String respiratory,
    required String digestive,
    required String neurology,
    required String circulatory,
    required String vocal,
    required String head,
    required String speech,
    required String lips,
    required String teeth,
    required String palate,
    required String tongue,
    required String upperJaw,
    required String lowerJaw,
    required String pharynx,
    required String throat,
    // Diagnosis
    required String diagnosis,
  }) async {
    emit(AddLoadingState());

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final scheduleGenerator = GenerateSchedule();

      scheduleSesoins = await scheduleGenerator.generateScheduleWithFallback(
          startDate: startDate,
          endDate: endDate,
          duration: period,
          childName: name,
          goalsList: selectedGoals);

      final doctorIdSnap =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final doctorId = doctorIdSnap['Doctor_id'];
      final doctorName = doctorIdSnap['Doctor_Name'];
      final doctorPhone = doctorIdSnap['Doctor_phone'];
      id = doctorIdSnap['lastChildId'];

      id++;

      final newChild = Child(
        id: id,
        name: name,
        age: age,
        dateOfBirth: dateOfBirth,
        startDate: startDate,
        endDate: endDate,
        period: period,
        parentPhone: parentPhone,
        notes: notes,
        school: school,
        residence: residence,
        gender: gender,
        fatherOccupation: fatherOccupation,
        motherOccupation: motherOccupation,
        familyMembers: familyMembers,
        motherDiseasesDuringPregnancy: motherDiseasesDuringPregnancy,
        parentsRelationship: parentsRelationship,
        familyRelationship: familyRelationship,
        motherNature: motherNature,
        selectedGoals: selectedGoals,
        scheduleSesoins: scheduleSesoins,
        doctorId: doctorId,
        doctorName: doctorName,
        doctorPhone: doctorPhone,
        dailyNotes: const [{}],

        // Missing fields added here
        siblingsInfluence: siblingsInfluence,
        siblingCloseness: siblingCloseness,
        motherAge: motherAge,
        pregnancyNature: pregnancyNature,
        pregnancyComplications: pregnancyComplications,
        motherStressDuringPregnancy: motherStressDuringPregnancy,
        birthType: birthType,
        birthComplications: birthComplications,
        birthTiming: birthTiming,
        incubator: incubator,
        incubatorPeriod: incubatorPeriod,
        jaundice: jaundice,
        jaundiceRate: jaundiceRate,
        vaccinations: vaccinations,
        measles: measles,
        smallpox: smallpox,
        medications: medications,
        teething: teething,
        babbling: babbling,
        motherVoiceAttention: motherVoiceAttention,
        sittingAlone: sittingAlone,
        crawling: crawling,
        walking: walking,
        handPointing: handPointing,
        familyDisabilities: familyDisabilities,
        socialInteraction: socialInteraction,
        parentAbsence: parentAbsence,
        hearing: hearing,
        vision: vision,
        respiratory: respiratory,
        digestive: digestive,
        neurology: neurology,
        circulatory: circulatory,
        vocal: vocal,
        head: head,
        speech: speech,
        lips: lips,
        teeth: teeth,
        palate: palate,
        tongue: tongue,
        upperJaw: upperJaw,
        lowerJaw: lowerJaw,
        pharynx: pharynx,
        throat: throat,
        diagnosis: diagnosis,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("children")
          .doc(parentPhone)
          .set(newChild.toMap());

      await FirebaseFirestore.instance
          .collection("DailyNotes")
          .doc(parentPhone)
          .set({"notes": []});

      // Update the lastChildId in the doctor's document
      lastChildName=name;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({'lastChildId': id,"lastChildName":lastChildName});


      saveToFirestore();

      sendWhatsAppMessage(parentPhone, doctorId, name);
      Navigator.pop(context);
      emit(AddScuccesState());
    } catch (e) {
      emit(AddFailureState(e.toString()));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void AddGoal(Goal goal, String childId, BuildContext context) {
    emit(NumberofItemsPlusstate());
    if (selectedGoals.containsKey(childId)) {
      if (selectedGoals[childId]!.length < 7 &&
          !selectedGoals.containsKey(goal)) {
        selectedGoals[childId]!.add(goal);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You have reached the max limit of 7 goals for this child.',
              style: TextStyle(color: Colors.blue[400]),
            ),
          ),
        );
      }
    } else {
      selectedGoals[childId] = [goal];
    }
  }

  void saveTask() {}
}
