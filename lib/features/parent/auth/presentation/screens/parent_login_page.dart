import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:ajeal/helpers/url_launcher/url_launcher.dart';

class ParentLoginPage extends StatefulWidget {
  const ParentLoginPage({super.key});

  @override
  State<ParentLoginPage> createState() => _ParentLoginPageState();
}

class _ParentLoginPageState extends State<ParentLoginPage> {
  final _parentCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final parentCode = _parentCodeController.text.trim();
      if (parentCode.isEmpty) return;
      final childSnapshot = await FirebaseFirestore.instance
          .collection("Children")
          .doc(parentCode)
          .get();

      if (!childSnapshot.exists) {
        if (mounted) {
          _showErrorSnackBar(S.of(context).invalid_parent_code);
        }

        return;
      }

      final Child child = Child.fromJson(childSnapshot.data()!);
      final adminID = child.doctorId;

      final doctorSnapshot = await FirebaseFirestore.instance
          .collection("Doctors")
          .doc(adminID)
          .get();

      if (!doctorSnapshot.exists || doctorSnapshot.data() == null) {
        if (mounted)
          _showErrorSnackBar("Invalid admin code. Please try again.");
        return;
      }

      final doctorKey = doctorSnapshot.data()?['Doctor_id'];
      if (doctorKey == null) {
        if (mounted) _showErrorSnackBar(S.of(context).invalid_parent_code);
        return;
      }

      await saveToken(parentCode, doctorKey);

      if (!mounted) return;
      context.go('/parent/main', extra: {
        'parentCode': parentCode,
        'child': child,
        'adminId': doctorKey
      });
    } catch (e) {
      _showErrorSnackBar("An error occurred. Please try again later.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> saveToken(String parentCode, String doctorKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("ParentLogin", true);
    await prefs.setString("parentCode", parentCode);
    await prefs.setString("parentDoctorKey", doctorKey);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _parentCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildLoginForm(),
                const SizedBox(height: 24),
                _buildLoginButton(),
                const SizedBox(height: 24),
                _buildHelpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            shape: BoxShape.circle,
          ),
          child:
              const Icon(Icons.family_restroom, size: 50, color: Colors.teal),
        ),
        const SizedBox(height: 24),
        Text(
          S.of(context).welcome_back,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          S.of(context).sign_in_to_continue,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return TextFormField(
      controller: _parentCodeController,
      decoration: InputDecoration(
        labelText: S.of(context).parent_code,
        hintText: S.of(context).enter_parent_code,
        prefixIcon: const Icon(Icons.person_outline, color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal),
        ),
      ),
      validator: (value) => value == null || value.isEmpty
          ? 'Please enter your parent code'
          : null,
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              S.of(context).sign_in,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
    );
  }

  Widget _buildHelpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).need_help,
            style: TextStyle(color: Colors.grey.shade600)),
        TextButton(
          onPressed: () {
            LauncherHelper.launchUrlFromString(
                "https://wa.me/+201004092979?text=السلام عليكم");
          },
          child: Text(
            S.of(context).contact_support,
            style: const TextStyle(
                color: Colors.teal, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
