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

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Persistent data
  static int id = 0;
  final Map<String, List<Goal>> selectedGoals = {}; // Used to store selected goals by parentPhone
  List<Map<String, Child>> children = []; // List of children with parentPhone as key
  List<Map<String, Child>> othersChildren = []; // List of children with parentPhone as key
  List<Map<String, dynamic>> scheduleSessions = [];

  // Tracking data
  String lastChattedWith = "Mohammed";
  String lastSessionWith = "Mohammed";
  String taskAddedFor = "Mohammed";
  String lastChildName = "Ahmed";

  // Get current user ID with null safety
  String? get _currentUserId => _auth.currentUser?.uid;

  // Get user document reference
  DocumentReference get _userDocRef => _firestore.collection("users").doc(_currentUserId);

  // Save children data to Firestore
  Future<void> saveToFirestore() async {
    emit(AddLoadingState());

    final userId = _currentUserId;
    if (userId == null) {
      emit(AddFailureState("User not authenticated"));
      return;
    }

    try {
      final userDoc = _userDocRef;
      var userData = await userDoc.get();
      id = userData["lastChildId"];

      // Save each child to Firestore
      for (var childMap in children) {
        await Future.forEach(
            childMap.entries, (MapEntry<String, Child> childEntry) async {
              await userDoc
                  .collection("children")
                  .doc(childEntry.key)
                  .set(childEntry.value.toMap());
            }
        );
      }

      // Update the last child ID
      await userDoc.set({"lastChildId": id}, SetOptions(merge: true));
      emit(AddSuccessState());
    } catch (e) {
      emit(AddFailureState(e.toString()));
    }
  }

  // Update user info with a specific key-value pair
  Future<void> updateUserInfo({required String key, required String value,required bool isOthers}) async {
    if (isOthers){return ;}
    final uid = _currentUserId;
    if (uid == null) {
      throw Exception("User not authenticated");
    }

    await _firestore.collection("users").doc(uid).update({
      key: value
    });
  }

  // Get doctor user information
  Future<Doctor?> getUserInfo() async {
    final uid = _currentUserId;
    if (uid == null) {
      return null;
    }

    try {
      final snapshot = await _firestore.collection("users").doc(uid).get();

      if (snapshot.exists) {
        return Doctor.fromJson(snapshot.data() ?? _getDefaultDoctorData());
      }

      return Doctor.fromJson(_getDefaultDoctorData());
    } catch (e) {
      return Doctor.fromJson(_getDefaultDoctorData());
    }
  }

  // Default doctor data
  Map<String, dynamic> _getDefaultDoctorData() {
    return {
      "Doctor_Name": "",
      "Doctor_id": "",
      "Doctor_phone": "",
      "lastChildId": 0,
      "lastChildName": "",
      "lastSessionWith": "",
      "taskAddedFor": "",
      "lastChattedWith": "",
    };
  }

  // Get all children data from Firestore
  Future<List<Map<String, Child>>> getAllDataFromFirestore() async {
    children = [];

    final userId = _currentUserId;
    if (userId == null) {
      return [];
    }

    try {
      final userDoc = await _firestore.collection("users").doc(userId).get();

      if (userDoc.exists) {
        // Get all documents in the children collection
        final childrenSnapshot = await _firestore
            .collection("users")
            .doc(userId)
            .collection("children")
            .get();

        for (var childDoc in childrenSnapshot.docs) {
          final child = Child.fromJson(childDoc.data());
          children.add({childDoc.id: child});
         }

        return children;
      }

      return [];
    } catch (e) {
      return [];
    }
  }
  Future<List<Map<String, Child>>> getAllChildrenFromOtherDoctors() async {
    othersChildren = [];
    final userId = _currentUserId;

    if (userId == null) {
      return [];
    }

    try {
      final userDoc = await _firestore.collection("users").doc(userId).get();
      if (!userDoc.exists) {
        return [];
      }

      // جلب كل الوثائق من OthersChildren
      final othersChildrenSnapshot = await _firestore
          .collection("users")
          .doc(userId)
          .collection("OthersChildren")
          .get();

      if (othersChildrenSnapshot.docs.isEmpty) {
        return [];
      }

      // استخراج أرقام هواتف الآباء مباشرة من doc.id
      List<String> parentPhones = othersChildrenSnapshot.docs.map((doc) => doc.id).toList();

      // تقسيم القائمة إلى مجموعات لا تزيد عن 10 عناصر لكل استعلام
      List<Future<QuerySnapshot>> futures = [];
      for (int i = 0; i < parentPhones.length; i += 10) {
        int end = (i + 10 < parentPhones.length) ? i + 10 : parentPhones.length;
        List<String> chunk = parentPhones.sublist(i, end);

        // استخدام FieldPath.documentId للبحث عن المستندات مباشرةً عبر معرّفها (parentPhone)
        futures.add(
          _firestore.collection("Children").where(FieldPath.documentId, whereIn: chunk).get(),
        );

    }


      // تنفيذ كل الاستعلامات بالتوازي
      List<QuerySnapshot> snapshots = await Future.wait(futures);
      /*
      * Every element in query return like list of documents of Children
      *
      * */

      // تخزين البيانات المسترجعة في خريطة
      Map<String, Child> mainChildrenMap = {};
      for (var snapshot in snapshots) {
        for (var doc in snapshot.docs) {

           mainChildrenMap[doc.id] = Child.fromJson(doc.data()as Map<String,dynamic>);
        }
      }

      // إنشاء Batch للكتابة بكفاءة عالية
      WriteBatch batch = _firestore.batch();

      // تحديث البيانات داخل OthersChildren
      for (var childDoc in othersChildrenSnapshot.docs) {
        final String parentPhone = childDoc.id;

        if (mainChildrenMap.containsKey(parentPhone)) {
          // استبدال البيانات إذا كان الطفل موجودًا في المجموعة الرئيسية
          final updatedChild = mainChildrenMap[parentPhone]!;

          othersChildren.add({parentPhone: updatedChild});

          batch.set(
            _firestore.collection("users").doc(userId).collection("OthersChildren").doc(parentPhone),
            updatedChild.toMap(),
          );
        } else {
          // الاحتفاظ بالبيانات القديمة إذا لم يتم العثور على الطفل
          final existingChild = Child.fromJson(childDoc.data());
          othersChildren.add({parentPhone: existingChild});
        }
      }

      // تنفيذ جميع التحديثات دفعة واحدة
      await batch.commit();

      return othersChildren;
    } catch (e) {
      print('Error getting children: $e');
      return [];
    }
  }

  /*
  * get others Children 
  * get all 
  * loop on the others Children 
  * replace it with its in the Children 
  * Update the Others Children 
  * 
  * 
  * */
  // Save a new child
  Future<void> saveChild(
      BuildContext context, {
        required String name,
        required String age,
        required DateTime dateOfBirth,
        required DateTime startDate,
        required DateTime endDate,
        required String period,
        required String parentPhone,
        required String parentPhoneNumber,
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
      final uid = _currentUserId;
      if (uid == null) {
        throw Exception("User not authenticated");
      }

      final scheduleGenerator = GenerateSchedule();

      // Generate schedule sessions
      scheduleSessions = await scheduleGenerator.generateScheduleWithFallback(
          startDate: startDate,
          endDate: endDate,
          duration: period,
          childName: name,
          goalsList: selectedGoals
      );

      // Get doctor information
      final doctorDoc = await _firestore.collection("users").doc(uid).get();
      final doctorData = doctorDoc.data() ?? {};

      final doctorId = doctorData['Doctor_id'] ?? '';
      final doctorName = doctorData['Doctor_Name'] ?? '';
      final doctorPhone = doctorData['Doctor_phone'] ?? '';
      id = doctorData['lastChildId'] ?? 0;

      // Increment child ID
      id++;

      // Create new child object
      final newChild = Child(
        id: id,
        name: name,
        age: age,
        dateOfBirth: dateOfBirth,
        startDate: startDate,
        endDate: endDate,
        period: period,
        parentPhone: parentPhone,
        parentPhoneNumber: parentPhoneNumber,
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
        scheduleSesoins: scheduleSessions,
        doctorId: doctorId,
        doctorName: doctorName,
        doctorPhone: doctorPhone,
        dailyNotes: const [{}],
        // Additional fields
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
        completedSessions: 0,
        analysis: ""

      );

      // Save child to Firestore
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("children")
          .doc(parentPhone)
          .set(newChild.toMap());
      // Save child to Firestore in Children Collection
      await _firestore
          .collection("Children")
          .doc(parentPhone)
          .set(newChild.toMap());

      // Initialize daily notes collection
      await _firestore
          .collection("DailyNotes")
          .doc(parentPhone)
          .set({"notes": []});

      // Update doctor information
      lastChildName = name;
      await _firestore
          .collection("users")
          .doc(uid)
          .update({
        'lastChildId': id,
        "lastChildName": lastChildName
      });
      
      // Save all data to Firestore
      await saveToFirestore();

        sendWhatsAppMessage(parentPhoneNumber, doctorId, name);

      // Send WhatsApp verification message

      Navigator.pop(context);
      emit(AddSuccessState());
    } catch (e) {
      emit(AddFailureState(e.toString()));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Add a goal for a specific child
  void addGoal(Goal goal, String childId, BuildContext context) {
    emit(NumberOfItemsPlusState());

    if (selectedGoals.containsKey(childId)) {
      if (selectedGoals[childId]!.length < 7 && !_containsGoal(selectedGoals[childId]!, goal)) {
        selectedGoals[childId]!.add(goal);
      } else {
        _showMaxGoalsMessage(context);
      }
    } else {
      selectedGoals[childId] = [goal];
    }
  }

  // Check if a goal already exists in the list
  bool _containsGoal(List<Goal> goals, Goal goal) {
    return goals.any((g) => g.goalName == goal.goalName);
  }

  // Show max goals message
  void _showMaxGoalsMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'You have reached the max limit of 7 goals for this child.',
          style: TextStyle(color: Colors.blue[400]),
        ),
      ),
    );
  }
}

