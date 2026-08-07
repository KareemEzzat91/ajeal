import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ajeal/features/admin/children/presentation/cubit/add_child/generate.dart';
import 'package:ajeal/features/admin/children/presentation/cubit/add_child/send_verification_message.dart';
import 'package:ajeal/core/di/service_locator.dart';
import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/core/models/goals_model/goals.dart';
import 'package:ajeal/features/admin/children/data/child_repository.dart';
import 'package:ajeal/features/admin/children/data/doctor_repository.dart';

part 'add_child_state.dart';

/// Cubit responsible ONLY for the add-child form submission
/// and goal selection tracking.
///
/// List loading is handled by ChildrenListCubit.
/// Doctor metadata updates are handled by DoctorMetaCubit.
class AddChildCubit extends Cubit<AddChildState> {
  AddChildCubit({
    ChildRepository? childRepository,
    DoctorRepository? doctorRepository,
    FirebaseAuth? auth,
  })  : _childRepo = childRepository ?? getIt<ChildRepository>(),
        _doctorRepo = doctorRepository ?? getIt<DoctorRepository>(),
        _auth = auth ?? FirebaseAuth.instance,
        super(AddChildInitial());

  final ChildRepository _childRepo;
  final DoctorRepository _doctorRepo;
  final FirebaseAuth _auth;

  // Goal selection – keyed by parentPhone (child identifier)
  final Map<String, List<Goal>> selectedGoals = {};

  // Schedule sessions generated during saveChild
  List<Map<String, dynamic>> scheduleSessions = [];

  String? get _userId => _auth.currentUser?.uid;

  // ─── Save Child ────────────────────────────────────────────────────────────

  /// Saves a new child to Firestore.
  /// Emits [AddLoadingState], then [AddSuccessState] or [AddFailureState].
  /// Does NOT accept BuildContext – call Navigator.pop in the screen on success.
  Future<void> saveChild({
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
      final trimmedPhone = parentPhone.trim();
      final userId = _userId;
      if (userId == null) throw Exception('User not authenticated');

      // Generate AI schedule
      final scheduleGenerator = ScheduleGeneratorService();
      scheduleSessions = await scheduleGenerator.generateScheduleWithFallback(
        startDate: startDate,
        endDate: endDate,
        duration: period,
        childName: name,
        goalsList: selectedGoals,
      );

      // Fetch doctor metadata
      final doctorData = await _doctorRepo.getDoctorData(userId);
      final doctorId = doctorData['Doctor_id'] as String? ?? '';
      final doctorName = doctorData['Doctor_Name'] as String? ?? '';
      final doctorPhone = doctorData['Doctor_phone'] as String? ?? '';
      final lastId = (doctorData['lastChildId'] as int? ?? 0) + 1;

      final newChild = Child(
        id: lastId,
        name: name,
        age: age,
        dateOfBirth: dateOfBirth,
        startDate: startDate,
        endDate: endDate,
        period: period,
        parentPhone: trimmedPhone,
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
        scheduleSessions: scheduleSessions,
        doctorId: doctorId,
        doctorName: doctorName,
        doctorPhone: doctorPhone,
        dailyNotes: const [{}],
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
        analysis: '',
      );

      await _childRepo.saveChild(userId, trimmedPhone, newChild);
      await _childRepo.updateLastChildMeta(userId, lastId, name);
      sendWhatsAppMessage(trimmedPhone, doctorId, name);

      emit(AddSuccessState());
    } catch (e) {
      emit(AddFailureState(e.toString()));
    }
  }

  // ─── Goal Selection ────────────────────────────────────────────────────────

  /// Adds a [goal] for [childId], capped at 7 goals.
  /// Emits [NumberOfItemsPlusState] to rebuild the badge counter.
  void addGoal(Goal goal, String childId, BuildContext context) {
    emit(NumberOfItemsPlusState());

    if (selectedGoals.containsKey(childId)) {
      final list = selectedGoals[childId]!;
      if (list.length < 7 && !_containsGoal(list, goal)) {
        list.add(goal);
      } else {
        _showMaxGoalsMessage(context);
      }
    } else {
      selectedGoals[childId] = [goal];
    }
  }

  bool _containsGoal(List<Goal> goals, Goal goal) =>
      goals.any((g) => g.goalName == goal.goalName);

  void _showMaxGoalsMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'You have reached the maximum limit of 7 goals for this child.'),
      ),
    );
  }
}
