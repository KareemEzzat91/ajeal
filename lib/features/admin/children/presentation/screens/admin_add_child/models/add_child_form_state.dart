import 'package:flutter/material.dart';

class AddChildFormState {
  // Basic Information Controllers
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController parentPhoneController;
  late TextEditingController schoolController;
  late TextEditingController residenceController;
  late TextEditingController notesController;
  late TextEditingController periodController;

  // Family Information Controllers
  late TextEditingController fatherOccupationController;
  late TextEditingController motherOccupationController;
  late TextEditingController familyMembersController;
  late TextEditingController siblingsInfluenceController;
  late TextEditingController siblingClosenessController;
  late TextEditingController motherAgeController;
  late TextEditingController parentsRelationshipController;
  late TextEditingController familyRelationshipController;
  late TextEditingController motherNatureController;

  // Developmental History Controllers
  // Pregnancy Phase
  late TextEditingController pregnancyNatureController;
  late TextEditingController motherDiseasesDuringPregnancyController;
  late TextEditingController pregnancyComplicationsController;
  late TextEditingController motherStressDuringPregnancyController;

  // Birth Phase
  late TextEditingController birthTypeController;
  late TextEditingController birthComplicationsController;
  late TextEditingController birthTimingController;

  // Post-Birth
  late TextEditingController incubatorController;
  late TextEditingController incubatorPeriodController;
  late TextEditingController jaundiceController;
  late TextEditingController jaundiceRateController;

  // Health History
  late TextEditingController vaccinationsController;
  late TextEditingController measlesController;
  late TextEditingController smallpoxController;
  late TextEditingController medicationsController;

  // First Year Growth
  late TextEditingController teethingController;
  late TextEditingController babblingController;
  late TextEditingController motherVoiceAttentionController;
  late TextEditingController sittingAloneController;
  late TextEditingController crawlingController;
  late TextEditingController walkingController;
  late TextEditingController handPointingController;

  // Psychological History
  late TextEditingController familyDisabilitiesController;

  // Social History
  late TextEditingController socialInteractionController;
  late TextEditingController parentAbsenceController;

  // Medical Examinations
  late TextEditingController hearingController;
  late TextEditingController visionController;
  late TextEditingController respiratoryController;
  late TextEditingController digestiveController;
  late TextEditingController neurologyController;
  late TextEditingController circulatoryController;
  late TextEditingController vocalController;
  late TextEditingController headController;
  late TextEditingController speechController;
  late TextEditingController lipsController;
  late TextEditingController teethController;
  late TextEditingController palateController;
  late TextEditingController tongueController;
  late TextEditingController upperJawController;
  late TextEditingController lowerJawController;
  late TextEditingController pharynxController;
  late TextEditingController throatController;

  // Diagnosis
  late TextEditingController diagnosisController;

  AddChildFormState() {
    nameController = TextEditingController();
    ageController = TextEditingController();
    parentPhoneController = TextEditingController();
    schoolController = TextEditingController();
    residenceController = TextEditingController();
    notesController = TextEditingController();
    periodController = TextEditingController();
    fatherOccupationController = TextEditingController();
    motherOccupationController = TextEditingController();
    familyMembersController = TextEditingController();
    siblingsInfluenceController = TextEditingController();
    siblingClosenessController = TextEditingController();
    motherAgeController = TextEditingController();
    parentsRelationshipController = TextEditingController();
    familyRelationshipController = TextEditingController();
    motherNatureController = TextEditingController();
    pregnancyNatureController = TextEditingController();
    motherDiseasesDuringPregnancyController = TextEditingController();
    pregnancyComplicationsController = TextEditingController();
    motherStressDuringPregnancyController = TextEditingController();
    birthTypeController = TextEditingController();
    birthComplicationsController = TextEditingController();
    birthTimingController = TextEditingController();
    incubatorController = TextEditingController();
    incubatorPeriodController = TextEditingController();
    jaundiceController = TextEditingController();
    jaundiceRateController = TextEditingController();
    vaccinationsController = TextEditingController();
    measlesController = TextEditingController();
    smallpoxController = TextEditingController();
    medicationsController = TextEditingController();
    teethingController = TextEditingController();
    babblingController = TextEditingController();
    motherVoiceAttentionController = TextEditingController();
    sittingAloneController = TextEditingController();
    crawlingController = TextEditingController();
    walkingController = TextEditingController();
    handPointingController = TextEditingController();
    familyDisabilitiesController = TextEditingController();
    socialInteractionController = TextEditingController();
    parentAbsenceController = TextEditingController();
    hearingController = TextEditingController();
    visionController = TextEditingController();
    respiratoryController = TextEditingController();
    digestiveController = TextEditingController();
    neurologyController = TextEditingController();
    circulatoryController = TextEditingController();
    vocalController = TextEditingController();
    headController = TextEditingController();
    speechController = TextEditingController();
    lipsController = TextEditingController();
    teethController = TextEditingController();
    palateController = TextEditingController();
    tongueController = TextEditingController();
    upperJawController = TextEditingController();
    lowerJawController = TextEditingController();
    pharynxController = TextEditingController();
    throatController = TextEditingController();
    diagnosisController = TextEditingController();
  }

  void dispose() {
    nameController.dispose();
    ageController.dispose();
    parentPhoneController.dispose();
    schoolController.dispose();
    residenceController.dispose();
    notesController.dispose();
    periodController.dispose();
    fatherOccupationController.dispose();
    motherOccupationController.dispose();
    familyMembersController.dispose();
    siblingsInfluenceController.dispose();
    siblingClosenessController.dispose();
    motherAgeController.dispose();
    parentsRelationshipController.dispose();
    familyRelationshipController.dispose();
    motherNatureController.dispose();
    pregnancyNatureController.dispose();
    motherDiseasesDuringPregnancyController.dispose();
    pregnancyComplicationsController.dispose();
    motherStressDuringPregnancyController.dispose();
    birthTypeController.dispose();
    birthComplicationsController.dispose();
    birthTimingController.dispose();
    incubatorController.dispose();
    incubatorPeriodController.dispose();
    jaundiceController.dispose();
    jaundiceRateController.dispose();
    vaccinationsController.dispose();
    measlesController.dispose();
    smallpoxController.dispose();
    medicationsController.dispose();
    teethingController.dispose();
    babblingController.dispose();
    motherVoiceAttentionController.dispose();
    sittingAloneController.dispose();
    crawlingController.dispose();
    walkingController.dispose();
    handPointingController.dispose();
    familyDisabilitiesController.dispose();
    socialInteractionController.dispose();
    parentAbsenceController.dispose();
    hearingController.dispose();
    visionController.dispose();
    respiratoryController.dispose();
    digestiveController.dispose();
    neurologyController.dispose();
    circulatoryController.dispose();
    vocalController.dispose();
    headController.dispose();
    speechController.dispose();
    lipsController.dispose();
    teethController.dispose();
    palateController.dispose();
    tongueController.dispose();
    upperJawController.dispose();
    lowerJawController.dispose();
    pharynxController.dispose();
    throatController.dispose();
    diagnosisController.dispose();
  }
}
