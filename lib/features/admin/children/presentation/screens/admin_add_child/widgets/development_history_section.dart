import 'package:flutter/material.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import '../models/add_child_form_state.dart';
import 'form_helpers.dart';

class DevelopmentHistorySection extends StatelessWidget {
  final AddChildFormState formState;

  const DevelopmentHistorySection({
    super.key,
    required this.formState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormSectionWidget(
          title: S.of(context).developmentalHistoryPregnancy,
          children: [
            AnimatedTextFieldWidget(
              controller: formState.pregnancyNatureController,
              label: S.of(context).pregnancyNature,
              icon: Icons.pregnant_woman,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.motherDiseasesDuringPregnancyController,
              label: S.of(context).mothersDiseasesDuringPregnancy,
              icon: Icons.medical_services,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.pregnancyComplicationsController,
              label: S.of(context).pregnancyComplications,
              icon: Icons.warning,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.motherStressDuringPregnancyController,
              label: S.of(context).mothersStressDuringPregnancy,
              icon: Icons.psychology_alt,
            ),
          ],
        ),
        FormSectionWidget(
          title: S.of(context).birthInformation,
          children: [
            AnimatedTextFieldWidget(
              controller: formState.birthTypeController,
              label: S.of(context).birthType,
              icon: Icons.child_care,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.birthComplicationsController,
              label: S.of(context).birthComplications,
              icon: Icons.warning,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.birthTimingController,
              label: S.of(context).birthTiming,
              icon: Icons.timer,
            ),
          ],
        ),
        FormSectionWidget(
          title: S.of(context).postBirthInformation,
          children: [
            AnimatedTextFieldWidget(
              controller: formState.incubatorController,
              label: S.of(context).incubator,
              icon: Icons.medical_services,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.incubatorPeriodController,
              label: S.of(context).incubatorPeriod,
              icon: Icons.access_time,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.jaundiceController,
              label: S.of(context).jaundice,
              icon: Icons.medical_information,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.jaundiceRateController,
              label: S.of(context).jaundiceRate,
              icon: Icons.show_chart,
            ),
          ],
        ),
      ],
    );
  }
}
