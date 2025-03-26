import 'package:ajeal/Admin/models/goals_model/Goals.dart';
import 'package:equatable/equatable.dart';

class Child extends Equatable {
  // Basic Information
  final int id;
  final String name;
  final String age;
  final DateTime dateOfBirth;
  final DateTime startDate;
  final DateTime endDate;
  final String period;
  final String parentPhone;
  final String parentPhoneNumber;
  final String notes;
  final String school;
  final String residence;
  final String gender;

  // Family Information
  final String fatherOccupation;
  final String motherOccupation;
  final String familyMembers;
  final String siblingsInfluence;
  final String siblingCloseness;
  final String motherAge;
  final String parentsRelationship;
  final String familyRelationship;
  final String motherNature;

  // Developmental History - Pregnancy Phase
  final String pregnancyNature;
  final String motherDiseasesDuringPregnancy;
  final String pregnancyComplications;
  final String motherStressDuringPregnancy;

  // Birth Phase
  final String birthType;
  final String birthComplications;
  final String birthTiming;

  // Post-Birth
  final String incubator;
  final String incubatorPeriod;
  final String jaundice;
  final String jaundiceRate;

  // Health History
  final String vaccinations;
  final String measles;
  final String smallpox;
  final String medications;

  // First Year Growth
  final String teething;
  final String babbling;
  final String motherVoiceAttention;
  final String sittingAlone;
  final String crawling;
  final String walking;
  final String handPointing;

  // Psychological History
  final String familyDisabilities;

  // Social History
  final String socialInteraction;
  final String parentAbsence;

  // Medical Examinations
  final String hearing;
  final String vision;
  final String respiratory;
  final String digestive;
  final String neurology;
  final String circulatory;
  final String vocal;
  final String head;
  final String speech;
  final String lips;
  final String teeth;
  final String palate;
  final String tongue;
  final String upperJaw;
  final String lowerJaw;
  final String pharynx;
  final String throat;

  // Diagnosis
  final String diagnosis;

  // Treatment Plan
  final List<Goal> selectedGoals;
  final List<Map<String, dynamic>> scheduleSesoins;
  final num completedSessions;
  final String analysis;

  // Doctor Information
  String doctorId;
  String doctorName;
   String doctorPhone;

  // Progress Tracking
  final List<Map<String, dynamic>> dailyNotes;

  // Comprehensive constructor with named parameters
  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.dateOfBirth,
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.parentPhone,
    required this.parentPhoneNumber,
    required this.notes,
    required this.school,
    required this.residence,
    required this.gender,

    // Family Information
    required this.fatherOccupation,
    required this.motherOccupation,
    required this.familyMembers,
    this.siblingsInfluence = '',
    this.siblingCloseness = '',
    this.motherAge = '',
    required this.parentsRelationship,
    required this.familyRelationship,
    required this.motherNature,

    // Developmental History - Pregnancy Phase
    this.pregnancyNature = '',
    required this.motherDiseasesDuringPregnancy,
    this.pregnancyComplications = '',
    this.motherStressDuringPregnancy = '',

    // Birth Phase
    this.birthType = '',
    this.birthComplications = '',
    this.birthTiming = '',

    // Post-Birth
    this.incubator = '',
    this.incubatorPeriod = '',
    this.jaundice = '',
    this.jaundiceRate = '',

    // Health History
    this.vaccinations = '',
    this.measles = '',
    this.smallpox = '',
    this.medications = '',

    // First Year Growth
    this.teething = '',
    this.babbling = '',
    this.motherVoiceAttention = '',
    this.sittingAlone = '',
    this.crawling = '',
    this.walking = '',
    this.handPointing = '',

    // Psychological History
    this.familyDisabilities = '',

    // Social History
    this.socialInteraction = '',
    this.parentAbsence = '',

    // Medical Examinations
    this.hearing = '',
    this.vision = '',
    this.respiratory = '',
    this.digestive = '',
    this.neurology = '',
    this.circulatory = '',
    this.vocal = '',
    this.head = '',
    this.speech = '',
    this.lips = '',
    this.teeth = '',
    this.palate = '',
    this.tongue = '',
    this.upperJaw = '',
    this.lowerJaw = '',
    this.pharynx = '',
    this.throat = '',

    // Diagnosis
    this.diagnosis = '',

    // Treatment Plan
    required this.selectedGoals,
    required this.scheduleSesoins,
    required this.completedSessions,

    // Doctor Information
    required this.doctorId,
    required this.doctorName,
    required this.doctorPhone,
    required this.analysis,

    // Progress Tracking
    required this.dailyNotes,
  });

  // Convert Child to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      // Basic Information
      'id': id,
      'name': name,
      'age': age,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'period': period,
      'parentPhone': parentPhone,
      'parentPhoneNumber': parentPhoneNumber,
      'notes': notes,
      'school': school,
      'residence': residence,
      'gender': gender,

      // Family Information
      'fatherOccupation': fatherOccupation,
      'motherOccupation': motherOccupation,
      'familyMembers': familyMembers,
      'siblingsInfluence': siblingsInfluence,
      'siblingCloseness': siblingCloseness,
      'motherAge': motherAge,
      'parentsRelationship': parentsRelationship,
      'familyRelationship': familyRelationship,
      'motherNature': motherNature,
      'completedSessions': completedSessions,

      // Developmental History - Pregnancy Phase
      'pregnancyNature': pregnancyNature,
      'motherDiseasesDuringPregnancy': motherDiseasesDuringPregnancy,
      'pregnancyComplications': pregnancyComplications,
      'motherStressDuringPregnancy': motherStressDuringPregnancy,

      // Birth Phase
      'birthType': birthType,
      'birthComplications': birthComplications,
      'birthTiming': birthTiming,

      // Post-Birth
      'incubator': incubator,
      'incubatorPeriod': incubatorPeriod,
      'jaundice': jaundice,
      'jaundiceRate': jaundiceRate,

      // Health History
      'vaccinations': vaccinations,
      'measles': measles,
      'smallpox': smallpox,
      'medications': medications,

      // First Year Growth
      'teething': teething,
      'babbling': babbling,
      'motherVoiceAttention': motherVoiceAttention,
      'sittingAlone': sittingAlone,
      'crawling': crawling,
      'walking': walking,
      'handPointing': handPointing,

      // Psychological History
      'familyDisabilities': familyDisabilities,

      // Social History
      'socialInteraction': socialInteraction,
      'parentAbsence': parentAbsence,

      // Medical Examinations
      'hearing': hearing,
      'vision': vision,
      'respiratory': respiratory,
      'digestive': digestive,
      'neurology': neurology,
      'circulatory': circulatory,
      'vocal': vocal,
      'head': head,
      'speech': speech,
      'lips': lips,
      'teeth': teeth,
      'palate': palate,
      'tongue': tongue,
      'upperJaw': upperJaw,
      'lowerJaw': lowerJaw,
      'pharynx': pharynx,
      'throat': throat,

      // Diagnosis
      'diagnosis': diagnosis,

      // Treatment Plan
      'goals': selectedGoals.map((goal) => goal.toMap()).toList(),
      'scheduleSesoins': scheduleSesoins,

      // Doctor Information
      'doctorId': doctorId,
      'doctorName': doctorName,
      "doctorPhone": doctorPhone,
      "analysis": analysis,

      // Progress Tracking
      'dailyNotes': dailyNotes,

      // Add a field to track the data model version
      'modelVersion': 2,
    };
  }

  // Create a developmental data map for separate storage if needed
  Map<String, dynamic> getDevelopmentalData() {
    return {
      // Family Information
      'siblingsInfluence': siblingsInfluence,
      'siblingCloseness': siblingCloseness,
      'motherAge': motherAge,
      'parentsRelationship': parentsRelationship,
      'familyRelationship': familyRelationship,
      'motherNature': motherNature,

      // Pregnancy Phase
      'pregnancyNature': pregnancyNature,
      'motherDiseasesDuringPregnancy': motherDiseasesDuringPregnancy,
      'pregnancyComplications': pregnancyComplications,
      'motherStressDuringPregnancy': motherStressDuringPregnancy,

      // Birth Phase
      'birthType': birthType,
      'birthComplications': birthComplications,
      'birthTiming': birthTiming,

      // Post-Birth
      'incubator': incubator,
      'incubatorPeriod': incubatorPeriod,
      'jaundice': jaundice,
      'jaundiceRate': jaundiceRate,

      // Health History
      'vaccinations': vaccinations,
      'measles': measles,
      'smallpox': smallpox,
      'medications': medications,

      // First Year Growth
      'teething': teething,
      'babbling': babbling,
      'motherVoiceAttention': motherVoiceAttention,
      'sittingAlone': sittingAlone,
      'crawling': crawling,
      'walking': walking,
      'handPointing': handPointing,

      // Psychological History
      'familyDisabilities': familyDisabilities,

      // Social History
      'socialInteraction': socialInteraction,
      'parentAbsence': parentAbsence,

      // Medical Examinations
      'hearing': hearing,
      'vision': vision,
      'respiratory': respiratory,
      'digestive': digestive,
      'neurology': neurology,
      'circulatory': circulatory,
      'vocal': vocal,
      'head': head,
      'speech': speech,
      'lips': lips,
      'teeth': teeth,
      'palate': palate,
      'tongue': tongue,
      'upperJaw': upperJaw,
      'lowerJaw': lowerJaw,
      'pharynx': pharynx,
      'throat': throat,

      // Diagnosis
      'diagnosis': diagnosis,
    };
  }

  // Factory constructor from JSON with improved field mapping and error handling
  factory Child.fromJson(Map<String, dynamic> json) {
    try {
      return Child(
        // Basic Information
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        age: json['age'] ?? '',
        dateOfBirth: _parseDateTime(json['dateOfBirth']),
        startDate: _parseDateTime(json['startDate']),
        endDate: _parseDateTime(json['endDate']),
        period: json['period'] ?? '',
        parentPhone: json['parentPhone'] ??
            json['parentOccupation'] ??
            '', // Handle legacy data
        parentPhoneNumber: json["parentPhoneNumber"],
        notes: json['notes'] ?? '',
        school: json['school'] ?? '',
        residence: json['residence'] ?? '',
        gender: json['gender'] ?? '',
        completedSessions: json['completedSessions']??0,
        // Family Information
        fatherOccupation: json['fatherOccupation'] ?? '',
        motherOccupation: json['motherOccupation'] ?? '',
        familyMembers: json['familyMembers'] ?? '',
        siblingsInfluence: json['siblingsInfluence'] ?? '',
        siblingCloseness: json['siblingCloseness'] ?? '',
        motherAge: json['motherAge'] ?? '',
        parentsRelationship: json['parentsRelationship'] ??
            json['relationshipBetweenParents'] ??
            '',
        familyRelationship: json['familyRelationship'] ?? '',
        motherNature: json['motherNature'] ?? '',

        // Developmental History - Pregnancy Phase
        pregnancyNature: json['pregnancyNature'] ?? '',
        motherDiseasesDuringPregnancy:
            json['motherDiseasesDuringPregnancy'] ?? '',
        pregnancyComplications: json['pregnancyComplications'] ?? '',
        motherStressDuringPregnancy: json['motherStressDuringPregnancy'] ?? '',

        // Birth Phase
        birthType: json['birthType'] ?? '',
        birthComplications: json['birthComplications'] ?? '',
        birthTiming: json['birthTiming'] ?? '',

        // Post-Birth
        incubator: json['incubator'] ?? '',
        incubatorPeriod: json['incubatorPeriod'] ?? '',
        jaundice: json['jaundice'] ?? '',
        jaundiceRate: json['jaundiceRate'] ?? '',

        // Health History
        vaccinations: json['vaccinations'] ?? '',
        measles: json['measles'] ?? '',
        smallpox: json['smallpox'] ?? '',
        medications: json['medications'] ?? '',

        // First Year Growth
        teething: json['teething'] ?? '',
        babbling: json['babbling'] ?? '',
        motherVoiceAttention: json['motherVoiceAttention'] ?? '',
        sittingAlone: json['sittingAlone'] ?? '',
        crawling: json['crawling'] ?? '',
        walking: json['walking'] ?? '',
        handPointing: json['handPointing'] ?? '',

        // Psychological History
        familyDisabilities: json['familyDisabilities'] ?? '',

        // Social History
        socialInteraction: json['socialInteraction'] ?? '',
        parentAbsence: json['parentAbsence'] ?? '',

        // Medical Examinations
        hearing: json['hearing'] ?? '',
        vision: json['vision'] ?? '',
        respiratory: json['respiratory'] ?? '',
        digestive: json['digestive'] ?? '',
        neurology: json['neurology'] ?? '',
        circulatory: json['circulatory'] ?? '',
        vocal: json['vocal'] ?? '',
        head: json['head'] ?? '',
        speech: json['speech'] ?? '',
        lips: json['lips'] ?? '',
        teeth: json['teeth'] ?? '',
        palate: json['palate'] ?? '',
        tongue: json['tongue'] ?? '',
        upperJaw: json['upperJaw'] ?? '',
        lowerJaw: json['lowerJaw'] ?? '',
        pharynx: json['pharynx'] ?? '',
        throat: json['throat'] ?? '',

        // Diagnosis
        diagnosis: json['diagnosis'] ?? '',

        // Treatment Plan
        selectedGoals: _parseGoals(json['goals']),
        scheduleSesoins: _parseScheduleSessions(json['scheduleSesoins']),

        // Doctor Information
        doctorId: json['doctorId'] ?? '',
        doctorName: json['doctorName'] ?? '',
        doctorPhone: json["doctorPhone"]??"",
        analysis: json["analysis"]??"",

        // Progress Tracking
        dailyNotes: _parseDailyNotes(json['dailyNotes']),
      );
    } catch (e) {
      // Return a minimal valid Child object to prevent app crashes
      return Child(
        id: 0,
        name: 'Error: ${json['name'] ?? 'Unknown'}',
        age: '',
        dateOfBirth: DateTime.now(),
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        period: '',
        parentPhone: '',parentPhoneNumber: "",
        notes: 'Error loading data: $e',
        school: '',
        residence: '',
        completedSessions: 0,
        gender: '',
        fatherOccupation: '',
        motherOccupation: '',
        familyMembers: '',
        parentsRelationship: '',
        familyRelationship: '',
        motherNature: '',
        motherDiseasesDuringPregnancy: '',
        selectedGoals: const [],
        scheduleSesoins: const [],
        doctorId: '',
        doctorName: '',
        doctorPhone: '',
        dailyNotes: const [],
        analysis: ""
      );
    }
  }

  // Helper methods for parsing JSON data safely
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  static List<Goal> _parseGoals(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      try {
        return value
            .map((goal) => Goal.fromMap(Map<String, dynamic>.from(goal)))
            .toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  static List<Map<String, dynamic>> _parseScheduleSessions(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      try {
        return value.map((e) => Map<String, dynamic>.from(e)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  static List<Map<String, dynamic>> _parseDailyNotes(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      try {
        return value.map((e) => Map<String, dynamic>.from(e)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  // Create a copy of this Child with updated fields
  Child copyWith({
    int? id,
    String? name,
    String? age,
    DateTime? dateOfBirth,
    DateTime? startDate,
    DateTime? endDate,
    String? period,
    String? parentPhone,
    String? parentPhoneNumber,
    String? notes,
    String? school,
    String? residence,
    String? gender,
    String? fatherOccupation,
    String? motherOccupation,
    String? familyMembers,
    String? siblingsInfluence,
    String? siblingCloseness,
    String? motherAge,
    String? parentsRelationship,
    String? familyRelationship,
    String? motherNature,
    String? pregnancyNature,
    String? motherDiseasesDuringPregnancy,
    String? pregnancyComplications,
    String? motherStressDuringPregnancy,
    String? birthType,
    String? birthComplications,
    String? birthTiming,
    String? incubator,
    String? incubatorPeriod,
    String? jaundice,
    String? jaundiceRate,
    String? vaccinations,
    String? measles,
    String? smallpox,
    String? medications,
    String? teething,
    String? babbling,
    String? motherVoiceAttention,

    String? sittingAlone,
    String? crawling,
    String? walking,
    String? handPointing,
    String? familyDisabilities,
    String? socialInteraction,
    String? parentAbsence,
    String? hearing,
    String? vision,
    String? respiratory,
    String? digestive,
    String? neurology,
    String? circulatory,
    String? vocal,
    String? head,
    String? speech,
    String? lips,
    String? teeth,
    String? palate,
    String? tongue,
    String? upperJaw,
    String? lowerJaw,
    String? pharynx,
    String? throat,
    String? diagnosis,
    List<Goal>? selectedGoals,
    List<Map<String, dynamic>>? scheduleSesoins,
    String? doctorId,
    String? doctorName,
    String? doctorPhone,
    String? analysis,
    int?completedSessions,
    List<Map<String, dynamic>>? dailyNotes,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      period: period ?? this.period,
      parentPhone: parentPhone ?? this.parentPhone,
      parentPhoneNumber: parentPhoneNumber ?? this.parentPhoneNumber,
      notes: notes ?? this.notes,
      school: school ?? this.school,
      completedSessions: this.completedSessions,
      residence: residence ?? this.residence,
      gender: gender ?? this.gender,
      fatherOccupation: fatherOccupation ?? this.fatherOccupation,
      motherOccupation: motherOccupation ?? this.motherOccupation,
      familyMembers: familyMembers ?? this.familyMembers,
      siblingsInfluence: siblingsInfluence ?? this.siblingsInfluence,
      siblingCloseness: siblingCloseness ?? this.siblingCloseness,
      motherAge: motherAge ?? this.motherAge,
      parentsRelationship: parentsRelationship ?? this.parentsRelationship,
      familyRelationship: familyRelationship ?? this.familyRelationship,
      motherNature: motherNature ?? this.motherNature,
      pregnancyNature: pregnancyNature ?? this.pregnancyNature,
      motherDiseasesDuringPregnancy:
          motherDiseasesDuringPregnancy ?? this.motherDiseasesDuringPregnancy,
      pregnancyComplications:
          pregnancyComplications ?? this.pregnancyComplications,
      motherStressDuringPregnancy:
          motherStressDuringPregnancy ?? this.motherStressDuringPregnancy,
      birthType: birthType ?? this.birthType,
      birthComplications: birthComplications ?? this.birthComplications,
      birthTiming: birthTiming ?? this.birthTiming,
      incubator: incubator ?? this.incubator,
      incubatorPeriod: incubatorPeriod ?? this.incubatorPeriod,
      jaundice: jaundice ?? this.jaundice,
      jaundiceRate: jaundiceRate ?? this.jaundiceRate,
      vaccinations: vaccinations ?? this.vaccinations,
      measles: measles ?? this.measles,
      smallpox: smallpox ?? this.smallpox,
      medications: medications ?? this.medications,
      teething: teething ?? this.teething,
      babbling: babbling ?? this.babbling,
      motherVoiceAttention: motherVoiceAttention ?? this.motherVoiceAttention,
      sittingAlone: sittingAlone ?? this.sittingAlone,
      crawling: crawling ?? this.crawling,
      walking: walking ?? this.walking,
      handPointing: handPointing ?? this.handPointing,
      familyDisabilities: familyDisabilities ?? this.familyDisabilities,
      socialInteraction: socialInteraction ?? this.socialInteraction,
      parentAbsence: parentAbsence ?? this.parentAbsence,
      hearing: hearing ?? this.hearing,
      vision: vision ?? this.vision,
      respiratory: respiratory ?? this.respiratory,
      digestive: digestive ?? this.digestive,
      neurology: neurology ?? this.neurology,
      circulatory: circulatory ?? this.circulatory,
      vocal: vocal ?? this.vocal,
      head: head ?? this.head,
      speech: speech ?? this.speech,
      lips: lips ?? this.lips,
      teeth: teeth ?? this.teeth,
      palate: palate ?? this.palate,
      tongue: tongue ?? this.tongue,
      upperJaw: upperJaw ?? this.upperJaw,
      lowerJaw: lowerJaw ?? this.lowerJaw,
      pharynx: pharynx ?? this.pharynx,
      throat: throat ?? this.throat,
      diagnosis: diagnosis ?? this.diagnosis,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      scheduleSesoins: scheduleSesoins ?? this.scheduleSesoins,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      dailyNotes: dailyNotes ?? this.dailyNotes,
      analysis: analysis??this.analysis
    );
  }

  @override
  List<Object?> get props => [
        // Basic Information
        id,
        name,
        age,
        dateOfBirth,
        startDate,
        endDate,
        period,
        parentPhone,
        parentPhoneNumber,
        notes,
        school,
        residence,
        gender,

        // Family Information
        fatherOccupation,
        motherOccupation,
        familyMembers,
        siblingsInfluence,
        siblingCloseness,
        motherAge,
        parentsRelationship,
        familyRelationship,
        motherNature,

        // Developmental History
        pregnancyNature,
        motherDiseasesDuringPregnancy,
        pregnancyComplications,
        motherStressDuringPregnancy,
        birthType,
        birthComplications,
        birthTiming,
        incubator,
        incubatorPeriod,
        jaundice,
        jaundiceRate,

        // Health History
        vaccinations,
        measles,
        smallpox,
        medications,

        // First Year Growth
        teething,
        babbling,
        motherVoiceAttention,
        sittingAlone,
        crawling,
        walking,
        handPointing,

        // Psychological & Social History
        familyDisabilities,
        socialInteraction,
        parentAbsence,

        // Medical Examinations
        hearing,
        vision,
        respiratory,
        digestive,
        neurology,
        circulatory,
        vocal,
        head,
        speech,
        lips,
        teeth,
        palate,
        tongue,
        upperJaw,
        lowerJaw,
        pharynx,
        throat,

        // Diagnosis
        diagnosis,

        // Treatment Plan & Other
        // Note: For complex objects like lists, consider if deep equality is needed
        doctorId,
        doctorName,
        doctorPhone,
    completedSessions,
    analysis,
      ];
}
