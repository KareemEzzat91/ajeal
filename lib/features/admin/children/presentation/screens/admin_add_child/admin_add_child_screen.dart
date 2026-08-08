import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ajeal/features/admin/children/presentation/cubit/add_child/add_child_cubit.dart';
import 'package:ajeal/features/admin/children/presentation/cubit/children_list/children_list_cubit.dart'
    as ajeal_children_list_cubit;
import 'package:ajeal/core/models/goals_model/goals.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:ajeal/core/routing/routes.dart';

import 'models/add_child_form_state.dart';
import 'widgets/basic_info_section.dart';
import 'widgets/treatment_period_section.dart';
import 'widgets/family_info_section.dart';
import 'widgets/development_history_section.dart';
import 'widgets/medical_history_section.dart';
import 'widgets/additional_info_section.dart';

class AdminAddChildScreen extends StatefulWidget {
  const AdminAddChildScreen({
    super.key,
  });

  @override
  State<AdminAddChildScreen> createState() => _AdminAddChildScreenState();
}

class _AdminAddChildScreenState extends State<AdminAddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  late AddChildFormState _formState;

  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? endDate;
  int age = 2;
  String selectedGender = "Male";
  List<Goal> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _formState = AddChildFormState();
  }

  @override
  void dispose() {
    _formState.dispose();
    super.dispose();
  }

  Future<bool> checkNumber(String phoneNumber) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not authenticated");
      }

      final childSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("children")
          .doc(phoneNumber)
          .get();

      return !childSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

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
            _formState.periodController.text = "3 أشهر";
          } else {
            _formState.periodController.text = _calculatePeriod(startDate!, endDate!);
          }
        } else if (dateType == endDate) {
          endDate = picked;
          if (startDate == null) {
            _formState.periodController.text = _calculatePeriod(DateTime.now(), endDate!);
          } else {
            _formState.periodController.text = _calculatePeriod(startDate!, endDate!);
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
          (currentDate.month == selectedDate!.month && currentDate.day < selectedDate!.day)) {
        age--;
      }
      _formState.ageController.text = age.toString();
    }
  }

  String _calculatePeriod(DateTime start, DateTime end) {
    final difference = end.difference(start);
    final years = (difference.inDays ~/ 365);
    final months = (difference.inDays % 365) ~/ 30;
    final days = (difference.inDays % 365) % 30;

    return "سنوات $years شهور $months أيام $days";
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
    if (!await checkNumber(_formState.parentPhoneController.text)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The Parent Phone number already exist Please Change The name '),
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
      name: _formState.nameController.text,
      age: _formState.ageController.text,
      selectedGoals: selectedItems,
      dateOfBirth: selectedDate ?? DateTime.now(),
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now(),
      period: _formState.periodController.text,
      parentPhone: _formState.parentPhoneController.text.trim() + _formState.nameController.text.trim(),
      parentPhoneNumber: _formState.parentPhoneController.text,
      notes: _formState.notesController.text,
      school: _formState.schoolController.text,
      residence: _formState.residenceController.text,
      gender: selectedGender,
      fatherOccupation: _formState.fatherOccupationController.text,
      motherOccupation: _formState.motherOccupationController.text,
      familyMembers: _formState.familyMembersController.text,
      siblingsInfluence: _formState.siblingsInfluenceController.text,
      siblingCloseness: _formState.siblingClosenessController.text,
      motherAge: _formState.motherAgeController.text,
      parentsRelationship: _formState.parentsRelationshipController.text,
      familyRelationship: _formState.familyRelationshipController.text,
      motherNature: _formState.motherNatureController.text,
      pregnancyNature: _formState.pregnancyNatureController.text,
      motherDiseasesDuringPregnancy: _formState.motherDiseasesDuringPregnancyController.text,
      pregnancyComplications: _formState.pregnancyComplicationsController.text,
      motherStressDuringPregnancy: _formState.motherStressDuringPregnancyController.text,
      birthType: _formState.birthTypeController.text,
      birthComplications: _formState.birthComplicationsController.text,
      birthTiming: _formState.birthTimingController.text,
      incubator: _formState.incubatorController.text,
      incubatorPeriod: _formState.incubatorPeriodController.text,
      jaundice: _formState.jaundiceController.text,
      jaundiceRate: _formState.jaundiceRateController.text,
      vaccinations: _formState.vaccinationsController.text,
      measles: _formState.measlesController.text,
      smallpox: _formState.smallpoxController.text,
      medications: _formState.medicationsController.text,
      teething: _formState.teethingController.text,
      babbling: _formState.babblingController.text,
      motherVoiceAttention: _formState.motherVoiceAttentionController.text,
      sittingAlone: _formState.sittingAloneController.text,
      crawling: _formState.crawlingController.text,
      walking: _formState.walkingController.text,
      handPointing: _formState.handPointingController.text,
      familyDisabilities: _formState.familyDisabilitiesController.text,
      socialInteraction: _formState.socialInteractionController.text,
      parentAbsence: _formState.parentAbsenceController.text,
      hearing: _formState.hearingController.text,
      vision: _formState.visionController.text,
      respiratory: _formState.respiratoryController.text,
      digestive: _formState.digestiveController.text,
      neurology: _formState.neurologyController.text,
      circulatory: _formState.circulatoryController.text,
      vocal: _formState.vocalController.text,
      head: _formState.headController.text,
      speech: _formState.speechController.text,
      lips: _formState.lipsController.text,
      teeth: _formState.teethController.text,
      palate: _formState.palateController.text,
      tongue: _formState.tongueController.text,
      upperJaw: _formState.upperJawController.text,
      lowerJaw: _formState.lowerJawController.text,
      pharynx: _formState.pharynxController.text,
      throat: _formState.throatController.text,
      diagnosis: _formState.diagnosisController.text,
    );
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
              context.pop(); // Dismiss loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Child added successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<ajeal_children_list_cubit.ChildrenListCubit>().loadChildren();
              context.pop(true); // Return to previous screen
            } else if (state is AddFailureState) {
              context.pop();
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
                        BasicInfoSection(
                          formState: _formState,
                          selectedDate: selectedDate,
                          onDateSelected: (date) => _selectDate(context, date),
                          selectedGender: selectedGender,
                          onGenderSelected: (gender) {
                            setState(() {
                              selectedGender = gender;
                            });
                          },
                        ),
                        TreatmentPeriodSection(
                          formState: _formState,
                          startDate: startDate,
                          endDate: endDate,
                          onStartDateSelected: (date) => _selectDate(context, startDate),
                          onEndDateSelected: (date) => _selectDate(context, endDate),
                        ),
                        FamilyInfoSection(formState: _formState),
                        DevelopmentHistorySection(formState: _formState),
                        MedicalHistorySection(formState: _formState),
                        AdditionalInfoSection(formState: _formState),
                        
                        // Goals Selection Button
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await context.push(Routes.adminChildrenAddGoals, extra: {
                              'phone': _formState.parentPhoneController.text.trim() + _formState.nameController.text.trim(),
                            });
                            if (result != null && result is List<Goal>) {
                              setState(() {
                                selectedItems = result;
                              });
                            }
                          },
                          icon: const Icon(Icons.add_task),
                          label: Text(S.of(context).selectGoals),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        if (selectedItems.isNotEmpty) _buildGoalsList(),
                        const SizedBox(height: 32),

                        // Save Button
                        ElevatedButton(
                          onPressed: () => _handleSave(addChildCubit, context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            S.of(context).saveChildInformation,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
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
}
