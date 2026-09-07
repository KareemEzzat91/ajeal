import 'package:flutter/material.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import '../models/add_child_form_state.dart';
import 'form_helpers.dart';

class TreatmentPeriodSection extends StatelessWidget {
  final AddChildFormState formState;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?) onStartDateSelected;
  final Function(DateTime?) onEndDateSelected;

  const TreatmentPeriodSection({
    super.key,
    required this.formState,
    required this.startDate,
    required this.endDate,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FormSectionWidget(
      title: S.of(context).treatmentPeriod,
      children: [
        DateSelectorWidget(
          label: S.of(context).startDate,
          value: startDate,
          onTap: () => onStartDateSelected(startDate),
        ),
        const SizedBox(height: 16),
        DateSelectorWidget(
          label: S.of(context).endDate,
          value: endDate,
          onTap: () => onEndDateSelected(endDate),
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.periodController,
          label: S.of(context).duration,
          icon: Icons.timer,
          readOnly: true,
        ),
      ],
    );
  }
}
