import 'package:flutter/material.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import '../models/add_child_form_state.dart';
import 'form_helpers.dart';

class AdditionalInfoSection extends StatelessWidget {
  final AddChildFormState formState;

  const AdditionalInfoSection({
    super.key,
    required this.formState,
  });

  @override
  Widget build(BuildContext context) {
    return FormSectionWidget(
      title: S.of(context).additionalInformation,
      children: [
        AnimatedTextFieldWidget(
          controller: formState.schoolController,
          label: S.of(context).schoolCollege,
          icon: Icons.school,
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.residenceController,
          label: S.of(context).residence,
          icon: Icons.home,
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.notesController,
          label: S.of(context).notes,
          icon: Icons.note,
          maxLines: 3,
        ),
      ],
    );
  }
}
