import 'package:flutter/material.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import '../models/add_child_form_state.dart';
import 'form_helpers.dart';

class BasicInfoSection extends StatelessWidget {
  final AddChildFormState formState;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final String selectedGender;
  final Function(String) onGenderSelected;

  const BasicInfoSection({
    super.key,
    required this.formState,
    required this.selectedDate,
    required this.onDateSelected,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FormSectionWidget(
      title: S.of(context).basicInformation,
      children: [
        AnimatedTextFieldWidget(
          controller: formState.nameController,
          label: S.of(context).childName,
          icon: Icons.child_care,
        ),
        const SizedBox(height: 16),
        _buildGenderSelector(),
        const SizedBox(height: 16),
        DateSelectorWidget(
          label: S.of(context).dateOfBirth,
          value: selectedDate,
          onTap: () => onDateSelected(selectedDate),
        ),
        const SizedBox(height: 16),
        AnimatedTextFieldWidget(
          controller: formState.ageController,
          label: S.of(context).age,
          icon: Icons.cake,
          readOnly: true,
        ),
      ],
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
                child: _buildGenderOption("Male", Icons.male, Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderOption("Female", Icons.female, Colors.pink),
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
      onTap: () => onGenderSelected(gender),
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
}
