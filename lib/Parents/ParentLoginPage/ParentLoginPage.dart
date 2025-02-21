import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildModel/ChildModel.dart';
import 'package:ajeal/Parents/ParentHomeScreen/ParentHomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentLoginPage extends StatefulWidget {
  @override
  _ParentLoginPageState createState() => _ParentLoginPageState();
}

class _ParentLoginPageState extends State<ParentLoginPage> {
  final _parentCodeController = TextEditingController();
  final _admincodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final parentCode = _parentCodeController.text.trim();
      final adminID = _admincodeController.text.trim();

      if (parentCode.isNotEmpty) {
        print(10);

        final doctorSnapshot = await FirebaseFirestore.instance
            .collection("Doctors")
            .doc(adminID)
            .get();

        if (doctorSnapshot.exists && doctorSnapshot.data()!.isNotEmpty) {
          print(20);
           final doctorKey = doctorSnapshot.data()!['Doctor_id'];
          print(doctorKey);
          final userDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(doctorKey)
              .collection("children")
              .doc(parentCode)
              .get();

          if (userDoc.exists && userDoc.data()!.isNotEmpty) {
            final child = Child.fromJson(userDoc.data()!);
            saveToken(parentCode,child,doctorKey);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (c) => ParentHomePage(
                  parentCode: parentCode,
                  child: child,
                  AdminId: doctorKey,
                ),
              ),
                    (Route<dynamic> route) => false
            );
          } else {
            _showErrorSnackBar("Invalid parent code. Please try xagain.");
          }
        } else {
          _showErrorSnackBar("Invalid admin code. Please try again.");
        }
      }
    } catch (e) {
      _showErrorSnackBar("An error occurred. Please try again later.${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }
  void saveToken(String parentCode, Child child, String doctorKey,)async{
    try {
      final pref = await SharedPreferences.getInstance();
      pref.setBool("ParentLogin", true);
      pref.setString("parentCode", parentCode);
      pref.setString("parentDoctorKey", doctorKey);

    }catch(e){
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
          child: Icon(
            Icons.family_restroom,
            size: 50,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Welcome Back!",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Please sign in to continue",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextFormField(
          controller: _parentCodeController,
          decoration: InputDecoration(
            labelText: "Parent Code",
            hintText: "Enter your parent code",
            prefixIcon: Icon(Icons.person_outline, color: Colors.teal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your parent code';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _admincodeController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: "Admin Code",
            hintText: "Enter admin code",
            prefixIcon: Icon(Icons.admin_panel_settings_outlined, color: Colors.teal),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the admin code';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
          : const Text(
        "Sign In",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHelpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Need help? ",
          style: TextStyle(color: Colors.grey.shade600),
        ),
        TextButton(
          onPressed: () {
            // Add help functionality
          },
          child: const Text(
            "Contact Support",
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _parentCodeController.dispose();
    _admincodeController.dispose();
    super.dispose();
  }
}