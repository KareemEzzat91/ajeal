import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:ajeal/features/admin/auth/presentation/cubit/sign_cubit.dart';
import 'package:ajeal/helpers/generated/l10n.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();

  // Add FocusNodes to manage focus properly
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _mobileFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => SignCubit(),
      child: BlocListener<SignCubit, SignState>(
        listener: (context, state) {
          if (state is SignFailureState) {
            Get.snackbar(
              "Validation ",
              state.error,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: const EdgeInsets.all(10),
              snackPosition: SnackPosition.TOP,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          // Ensure keyboard adjusts content
          resizeToAvoidBottomInset: true,
          body: Container(
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffF1F0EB),
                  Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                // Make sure scrolling works properly
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Center(
                        child: Hero(
                          tag: 'logo',
                          child: Image.asset(
                            "assets/images/Untitled design.png",
                            height: size.height * 0.15,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Welcome Text
                      Text(
                        S.of(context).register_now,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        S.of(context).enter_information_below,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),

                      const SizedBox(height: 24),

                      // Registration Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Name Field
                            _buildTextField(
                              controller: _nameController,
                              label: "Full Name",
                              icon: Icons.person_outline,
                              focusNode: _nameFocus,
                              nextFocus: _emailFocus,
                              validator: (val) {
                                if (val?.isEmpty ?? true) {
                                  return "Name is required";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Email Field
                            _buildTextField(
                              controller: _emailController,
                              label: "Email",
                              icon: Icons.email_outlined,
                              focusNode: _emailFocus,
                              nextFocus: _passwordFocus,
                              validator: (val) {
                                if (!val!.isEmail) {
                                  return "Please enter a valid email";
                                }
                                if (val.length < 10) {
                                  return "Email should be at least 10 characters";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Password Field
                            _buildTextField(
                              controller: _passwordController,
                              label: "Password",
                              icon: Icons.lock_outline,
                              isPassword: true,
                              focusNode: _passwordFocus,
                              nextFocus: _mobileFocus,
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Mobile Field
                            _buildTextField(
                              controller: _mobileController,
                              label: "Mobile Number",
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              focusNode: _mobileFocus,
                              validator: (val) {
                                if (val?.length != 11) {
                                  return "Please enter a valid 11-digit mobile number";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 32),

                            // Sign Up Button
                            BlocBuilder<SignCubit, SignState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: state is SignLoadingState
                                      ? null
                                      : () {
                                          // Handle form submission
                                          FocusScope.of(context).unfocus();
                                          context.read<SignCubit>().signUp(
                                                context,
                                                _formKey,
                                                _emailController,
                                                _nameController,
                                                _passwordController,
                                                _mobileController,
                                              );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff0186c7),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: Size(size.width, 0),
                                    elevation: 2,
                                  ),
                                  child: state is SignLoadingState
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).alreadyMember,
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                TextButton(
                                  onPressed: () => context.go('/admin/login'),
                                  child: Text(
                                    S.of(context).loginPage,
                                    style: const TextStyle(
                                      color: Color(0xff0186c7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Add extra space at bottom for keyboard
                            SizedBox(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator,
      // Prevent keyboard issues by disabling auto-validation
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // Handle text field submission and focus changes
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      style: const TextStyle(color: Colors.grey),
      // Handle editing complete event
      onEditingComplete: () {
        // This prevents the flickering issue in some cases
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xff0186c7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff0186c7)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
