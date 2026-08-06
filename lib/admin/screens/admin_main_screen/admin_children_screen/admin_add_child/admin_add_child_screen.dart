import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/admin_add_child/add_child_cubit/add_child_cubit.dart';
import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/admin_children_select_goals/admin_select_goals_screen.dart';
import 'package:ajeal/core/models/goals_model/goals.dart';
import 'package:ajeal/features/admin/children/presentation/cubit/children_list/children_list_cubit.dart'
    as ajeal_children_list_cubit;
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAddChildScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  const AdminAddChildScreen(
      {super.key, required this.doctorId, required this.doctorName});

  @override
  State<AdminAddChildScreen> createState() => _AdminAddChildScreenState();
}

class _AdminAddChildScreenState extends State<AdminAddChildScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _initializeControllers();
  }

  void _initializeControllers() {
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

  @override
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
    super.dispose();
  }

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

  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? endDate;
  int age = 2;
  String selectedGender = "Male";
  List<Goal> selectedItems = [];
  Future<void> _selectDate(BuildContext context, DateTime? dateType) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateType ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: dateType == selectedDate ? DateTime.now() : DateTime.utc(2030),
    );

    if (picked != null) {
      setState(() {
        if (dateType == selectedDate) {
          selectedDate = picked;
          _updateAge();
        } else if (dateType == startDate) {
          startDate = picked;
          if (endDate == null) {
            periodController.text = "3 أشهر"; // Default period of 3 months
          } else {
            periodController.text = _calculatePeriod(startDate!, endDate!);
          }
        } else if (dateType == endDate) {
          endDate = picked;
          if (startDate == null) {
            periodController.text = _calculatePeriod(DateTime.now(), endDate!);
          } else {
            periodController.text = _calculatePeriod(startDate!, endDate!);
          }
        }
      });
    }
  }

  void _updateAge() {
    if (selectedDate != null) {
      final currentDate = DateTime.now();
      age = currentDate.year - selectedDate!.year;

      if (currentDate.month < selectedDate!.month ||
          (currentDate.month == selectedDate!.month &&
              currentDate.day < selectedDate!.day)) {
        age--;
      }

      ageController.text = age.toString();
    }
  }

  String _calculatePeriod(DateTime start, DateTime end) {
    final difference = end.difference(start);
    final years = (difference.inDays ~/ 365);
    final months = (difference.inDays % 365) ~/ 30;
    final days = (difference.inDays % 365) % 30;

    return "سنوات $years شهور $months أيام $days";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => AddChildCubit(),
      child: Builder(builder: (context) {
        final addChildCubit = context.read<AddChildCubit>();

        return BlocListener<AddChildCubit, AddChildState>(
          listener: (context, state) {
            if (state is AddLoadingState) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Saving child information...'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is AddSuccessState) {
              Navigator.pop(context); // Dismiss loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Child added successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Refresh the list and pop the screen
              context
                  .read<ajeal_children_list_cubit.ChildrenListCubit>()
                  .loadChildren();
              Navigator.pop(context); // Dismiss Add Child screen
            } else if (state is AddFailureState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('An error occurred.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: theme.primaryColor,
              title: const Text(
                "Add New Child",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.primaryColor,
                    Colors.white,
                  ],
                ),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSection(
                          S.of(context).basicInformation,
                          [
                            _buildAnimatedTextField(
                              controller: nameController,
                              label: S.of(context).childName,
                              icon: Icons.child_care,
                            ),
                            const SizedBox(height: 16),
                            _buildGenderSelector(),
                            const SizedBox(height: 16),
                            _buildDateSelector(
                              label: S.of(context).dateOfBirth,
                              value: selectedDate,
                              onTap: () => _selectDate(context, selectedDate),
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: ageController,
                              label: S.of(context).age,
                              icon: Icons.cake,
                              readOnly: true,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).treatmentPeriod,
                          [
                            _buildDateSelector(
                              label: S.of(context).startDate,
                              value: startDate,
                              onTap: () => _selectDate(context, startDate),
                            ),
                            const SizedBox(height: 16),
                            _buildDateSelector(
                              label: S.of(context).endDate,
                              value: endDate,
                              onTap: () => _selectDate(context, endDate),
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: periodController,
                              label: S.of(context).duration,
                              icon: Icons.timer,
                              readOnly: true,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).familyInformation,
                          [
                            _buildAnimatedTextField(
                                controller: parentPhoneController,
                                label: S.of(context).parentsContact,
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                validator: (val) {
                                  if (val!.length != 12) {
                                    return "the Phone number must be like 20xxxxxxxxxx";
                                  } //'+
                                  return null;
                                }),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: fatherOccupationController,
                              label: S.of(context).fathersOccupation,
                              icon: Icons.work,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: motherOccupationController,
                              label: S.of(context).mothersOccupation,
                              icon: Icons.work,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: familyMembersController,
                              label: S.of(context).familyMembers,
                              icon: Icons.family_restroom,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: siblingsInfluenceController,
                              label: S.of(context).siblingsInfluence,
                              icon: Icons.people,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: siblingClosenessController,
                              label: S.of(context).siblingCloseness,
                              icon: Icons.people_outline,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: motherAgeController,
                              label: S.of(context).mothersAge,
                              icon: Icons.person,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: parentsRelationshipController,
                              label: S.of(context).parentsRelationship,
                              icon: Icons.favorite,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: familyRelationshipController,
                              label: S.of(context).familyRelationship,
                              icon: Icons.groups,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: motherNatureController,
                              label: S.of(context).mothersNature,
                              icon: Icons.psychology,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).developmentalHistoryPregnancy,
                          [
                            _buildAnimatedTextField(
                              controller: pregnancyNatureController,
                              label: S.of(context).pregnancyNature,
                              icon: Icons.pregnant_woman,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller:
                                  motherDiseasesDuringPregnancyController,
                              label:
                                  S.of(context).mothersDiseasesDuringPregnancy,
                              icon: Icons.medical_services,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: pregnancyComplicationsController,
                              label: S.of(context).pregnancyComplications,
                              icon: Icons.warning,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: motherStressDuringPregnancyController,
                              label: S.of(context).mothersStressDuringPregnancy,
                              icon: Icons.psychology_alt,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).birthInformation,
                          [
                            _buildAnimatedTextField(
                              controller: birthTypeController,
                              label: S.of(context).birthType,
                              icon: Icons.child_care,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: birthComplicationsController,
                              label: S.of(context).birthComplications,
                              icon: Icons.warning,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: birthTimingController,
                              label: S.of(context).birthTiming,
                              icon: Icons.timer,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).postBirthInformation,
                          [
                            _buildAnimatedTextField(
                              controller: incubatorController,
                              label: S.of(context).incubator,
                              icon: Icons.medical_services,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: incubatorPeriodController,
                              label: S.of(context).incubatorPeriod,
                              icon: Icons.access_time,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: jaundiceController,
                              label: S.of(context).jaundice,
                              icon: Icons.medical_information,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: jaundiceRateController,
                              label: S.of(context).jaundiceRate,
                              icon: Icons.show_chart,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).healthHistory,
                          [
                            _buildAnimatedTextField(
                              controller: vaccinationsController,
                              label: S.of(context).vaccinations,
                              icon: Icons.vaccines,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: measlesController,
                              label: S.of(context).measles,
                              icon: Icons.coronavirus,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: smallpoxController,
                              label: S.of(context).smallpox,
                              icon: Icons.coronavirus_outlined,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: medicationsController,
                              label: S.of(context).medications,
                              icon: Icons.medication,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).firstYearGrowth,
                          [
                            _buildAnimatedTextField(
                              controller: teethingController,
                              label: S.of(context).teething,
                              icon: Icons.face,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: babblingController,
                              label: S.of(context).babbling,
                              icon: Icons.record_voice_over,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: motherVoiceAttentionController,
                              label: S.of(context).attentionToMothersVoice,
                              icon: Icons.hearing,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: sittingAloneController,
                              label: S.of(context).sittingAlone,
                              icon: Icons.accessible,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: crawlingController,
                              label: S.of(context).crawling,
                              icon: Icons.directions_walk,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: walkingController,
                              label: S.of(context).walking,
                              icon: Icons.directions_run,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: handPointingController,
                              label: S.of(context).handPointing,
                              icon: Icons.back_hand,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).psychologicalHistory,
                          [
                            _buildAnimatedTextField(
                              controller: familyDisabilitiesController,
                              label: S.of(context).familyDisabilities,
                              icon: Icons.accessibility_new,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).socialHistory,
                          [
                            _buildAnimatedTextField(
                              controller: socialInteractionController,
                              label: S.of(context).socialInteraction,
                              icon: Icons.people_alt,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: parentAbsenceController,
                              label: S.of(context).parentAbsence,
                              icon: Icons.person_off,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).medicalExaminations,
                          [
                            _buildAnimatedTextField(
                              controller: hearingController,
                              label: S.of(context).hearing,
                              icon: Icons.hearing,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: visionController,
                              label: S.of(context).vision,
                              icon: Icons.visibility,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: respiratoryController,
                              label: S.of(context).respiratory,
                              icon: Icons.air,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: digestiveController,
                              label: S.of(context).digestive,
                              icon: Icons.restaurant,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: neurologyController,
                              label: S.of(context).neurology,
                              icon: Icons.psychology,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: circulatoryController,
                              label: S.of(context).circulatory,
                              icon: Icons.favorite,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: vocalController,
                              label: S.of(context).vocal,
                              icon: Icons.record_voice_over,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).oralExamination,
                          [
                            _buildAnimatedTextField(
                              controller: headController,
                              label: S.of(context).head,
                              icon: Icons.face,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: speechController,
                              label: S.of(context).speech,
                              icon: Icons.speaker_notes,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: lipsController,
                              label: S.of(context).lips,
                              icon: Icons.face_retouching_natural,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: teethController,
                              label: S.of(context).teeth,
                              icon: Icons.face_outlined,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: palateController,
                              label: S.of(context).palate,
                              icon: Icons.face_2,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: tongueController,
                              label: S.of(context).tongue,
                              icon: Icons.translate,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: upperJawController,
                              label: S.of(context).upperJaw,
                              icon: Icons.medical_information,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: lowerJawController,
                              label: S.of(context).lowerJaw,
                              icon: Icons.medical_information,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: pharynxController,
                              label: S.of(context).pharynx,
                              icon: Icons.health_and_safety,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: throatController,
                              label: S.of(context).throat,
                              icon: Icons.health_and_safety_outlined,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).diagnosis,
                          [
                            _buildAnimatedTextField(
                              controller: diagnosisController,
                              label: S.of(context).diagnosis,
                              icon: Icons.medical_information,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).additionalInformation,
                          [
                            _buildAnimatedTextField(
                              controller: schoolController,
                              label: S.of(context).schoolCollege,
                              icon: Icons.school,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: residenceController,
                              label: S.of(context).residence,
                              icon: Icons.home,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedTextField(
                              controller: notesController,
                              label: S.of(context).notes,
                              icon: Icons.note_alt_outlined,
                            ),
                          ],
                        ),
                        _buildSection(
                          S.of(context).goals,
                          [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add_task),
                              label: Text(S.of(context).selectGoals),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  selectedItems = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminSelectGoals(
                                        phone: parentPhoneController.text,
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildGoalsList(),
                          ],
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: theme.primaryColor,
                          ),
                          onPressed: () => _handleSave(addChildCubit, context),
                          child: Text(
                            S.of(context).saveChildInformation,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      bool readOnly = false,
      TextInputType? keyboardType,
      final String? Function(String?)? validator}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: validator ??
              (val) {
                if (val!.isEmpty) return "$label cannot be empty";
                return null;
              }),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          value != null
              ? "${value.day}/${value.month}/${value.year}"
              : "Select Date",
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gender",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  "Male",
                  Icons.male,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderOption(
                  "Female",
                  Icons.female,
                  Colors.pink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon, Color color) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: selectedItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(selectedItems[index].goalName),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    selectedItems.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSave(AddChildCubit bloc, BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (!await checkNumber(parentPhoneController.text)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'The Parent Phone number already exist Please Change The name '),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!context.mounted) return;

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add goals first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    bloc.saveChild(
      name: nameController.text,
      age: ageController.text,
      selectedGoals: selectedItems,
      dateOfBirth: selectedDate ?? DateTime.now(),
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now(),
      period: periodController.text,
      parentPhone: parentPhoneController.text.trim() +
          nameController.text
              .trim(), // Fixed parameter name//number+ name Likecode
      parentPhoneNumber: parentPhoneController.text, //Only Number
      notes: notesController.text,
      school: schoolController.text,
      residence: residenceController.text,
      gender: selectedGender,

      // Family Information
      fatherOccupation: fatherOccupationController.text,
      motherOccupation: motherOccupationController.text,
      familyMembers: familyMembersController.text,
      siblingsInfluence: siblingsInfluenceController.text,
      siblingCloseness: siblingClosenessController.text,
      motherAge: motherAgeController.text,
      parentsRelationship: parentsRelationshipController.text,
      familyRelationship: familyRelationshipController.text,
      motherNature: motherNatureController.text,
      // Developmental History - Pregnancy Phase
      pregnancyNature: pregnancyNatureController.text,
      motherDiseasesDuringPregnancy:
          motherDiseasesDuringPregnancyController.text,
      pregnancyComplications: pregnancyComplicationsController.text,
      motherStressDuringPregnancy: motherStressDuringPregnancyController.text,
      // Birth Phase
      birthType: birthTypeController.text,
      birthComplications: birthComplicationsController.text,
      birthTiming: birthTimingController.text,
      // Post-Birth
      incubator: incubatorController.text,
      incubatorPeriod: incubatorPeriodController.text,
      jaundice: jaundiceController.text,
      jaundiceRate: jaundiceRateController.text,
      // Health History
      vaccinations: vaccinationsController.text,
      measles: measlesController.text,
      smallpox: smallpoxController.text,
      medications: medicationsController.text,
      // First Year Growth
      teething: teethingController.text,
      babbling: babblingController.text,
      motherVoiceAttention: motherVoiceAttentionController.text,
      sittingAlone: sittingAloneController.text,
      crawling: crawlingController.text,
      walking: walkingController.text,
      handPointing: handPointingController.text,
      // Psychological History
      familyDisabilities: familyDisabilitiesController.text,
      // Social History
      socialInteraction: socialInteractionController.text,
      parentAbsence: parentAbsenceController.text,
      // Medical Examinations
      hearing: hearingController.text,
      vision: visionController.text,
      respiratory: respiratoryController.text,
      digestive: digestiveController.text,
      neurology: neurologyController.text,
      circulatory: circulatoryController.text,
      vocal: vocalController.text,
      head: headController.text,
      speech: speechController.text,
      lips: lipsController.text,
      teeth: teethController.text,
      palate: palateController.text,
      tongue: tongueController.text,
      upperJaw: upperJawController.text,
      lowerJaw: lowerJawController.text,
      pharynx: pharynxController.text,
      throat: throatController.text,
      // Diagnosis
      diagnosis: diagnosisController.text,
    );
  }

  Future<bool> checkNumber(String phoneNumber) async {
    try {
      // Get current user ID
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not authenticated");
      }

      // Check if a child document with this phone number exists
      final childSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("children")
          .doc(phoneNumber)
          .get();

      // Return false if document exists (number is already used)
      // Return true if document doesn't exist (number is available)
      return !childSnapshot.exists;
    } catch (e) {
      // In case of error, assume number might be in use for safety
      return false;
    }
  }
}
