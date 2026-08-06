// Helper methods to show dialog messages
import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/child_cards.dart';
import 'package:ajeal/admin/models/child_model/child_model.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

void showSuccessMessage(BuildContext context, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    text: message,
  );
}

void showErrorMessage(BuildContext context, String error) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    text: 'Error: $error',
  );
}
Future<dynamic> showCustomDialog(BuildContext context, {Child? child}) {
  // Determine if we're handling an "Others" case or not
  final bool isOthers = child == null;

  // Initialize controllers with existing values if available
  final TextEditingController doctorNameController = TextEditingController(
  );

  final TextEditingController doctorIdController = TextEditingController(
  );

  final TextEditingController childCodeController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  return QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    barrierDismissible: true,
    confirmBtnText: 'Save',
    customAsset: 'assets/images/giphy.gif',
    widget: Form(
      key: formKey,
      child: Column(
        children: [
          // Field for Doctor Name
          if (!isOthers)
            TextFormField(
              controller: doctorNameController,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Doctor Name',
                hintText: 'Enter Doctor Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter doctor name';
                }
                return null;
              },
            ),

          if (!isOthers) const SizedBox(height: 16),

          // Field for Doctor ID
          if (!isOthers)
            TextFormField(
              controller: doctorIdController,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Doctor ID',
                hintText: 'Enter Doctor ID',
                prefixIcon: Icon(Icons.numbers_outlined),
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter doctor ID';
                }
                return null;
              },
            ),

          if (isOthers) const SizedBox(height: 16),

          // Field for Child Code
          if (isOthers)
            TextFormField(
              controller: childCodeController,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Child Code',
                hintText: 'Enter Child Code',
                prefixIcon: Icon(Icons.numbers_outlined),
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter child code';
                }
                return null;
              },
            ),
        ],
      ),
    ),
    onConfirmBtnTap: () async {
      // Validate form
      if (formKey.currentState?.validate() != true) {
        return;
      }

      try {
        if (isOthers) {
          await handleOthersCase(context, childCodeController.text);
        } else {
          await handleDoctorAssignment(
              context,
              child,
              doctorNameController.text,
              doctorIdController.text
          );
        }
      } catch (e) {
        // Handle errors centrally
        if (!context.mounted) return;
        showErrorMessage(context, e.toString());
      }
    },
  );
}
