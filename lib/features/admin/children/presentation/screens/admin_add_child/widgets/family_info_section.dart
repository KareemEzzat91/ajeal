import 'package:flutter/material.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import '../models/add_child_form_state.dart';
import 'form_helpers.dart';

class FamilyInfoSection extends StatelessWidget {
  final AddChildFormState formState;

  const FamilyInfoSection({
    super.key,
    required this.formState,
  });

  @override
  Widget build(BuildContext context) {
    return FormSectionWidget(
      title: S.of(context).familyInformation,
      children: [
        AnimatedTextFieldWidget(
          controller: formState.parentPhoneController,
          label: S.of(context).parentsContact,
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (val) {
            if (val!.length != 12) {
              return "the Phone number must be like 20xxxxxxxxxx";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.fatherOccupationController,
          label: S.of(context).fathersOccupation,
          icon: Icons.work,
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.motherOccupationController,
          label: S.of(context).mothersOccupation,
          icon: Icons.work,
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.familyMembersController,
          label: S.of(context).familyMembers,
          icon: Icons.family_restroom,
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.siblingsInfluenceController,
          label: S.of(context).siblingsInfluence,
          icon: Icons.people,
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.siblingClosenessController,
          label: S.of(context).siblingCloseness,
          icon: Icons.people_outline,
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.motherAgeController,
          label: S.of(context).mothersAge,
          icon: Icons.person,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.parentsRelationshipController,
          label: S.of(context).parentsRelationship,
          icon: Icons.favorite,
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.familyRelationshipController,
          label: S.of(context).familyRelationship,
          icon: Icons.groups,
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.motherNatureController,
          label: S.of(context).mothersNature,
          icon: Icons.psychology,
        ),
      ],
    );
  }
}
