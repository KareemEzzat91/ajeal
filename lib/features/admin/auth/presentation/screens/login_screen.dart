import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:ajeal/features/admin/auth/presentation/cubit/sign_cubit.dart';
import 'package:ajeal/helpers/generated/l10n.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final s = S.of(context);

    return BlocProvider(
      create: (context) => SignCubit(),
      child: BlocConsumer<SignCubit, SignState>(
        listener: (context, state) {
          if (state is SignFailureState) {
            Get.snackbar(
              "Error",
              state.error,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: const EdgeInsets.all(10),
              snackPosition: SnackPosition.TOP,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 16,
                        bottom: MediaQuery.of(context)
                            .viewInsets
                            .bottom, // ADJUST HERE
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              constraints.maxHeight, // ENSURE FULL HEIGHT
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Hero(
                                tag: 'logo',
                                child: Image.asset(
                                  "assets/images/Untitled design.png",
                                  height: size.height * 0.2,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              s.letsSignIn,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              s.enter_information_below,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                            const SizedBox(height: 32),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _buildTextField(
                                    focusNode: _emailFocus,
                                    controller: _emailController,
                                    label: "Email",
                                    nextFocus: _passwordFocus,
                                    icon: Icons.email_outlined,
                                    validator: (val) {
                                      if (val == null || !val.isEmail) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    focusNode: _passwordFocus,
                                    controller: _passwordController,
                                    label: "Password",
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    validator: (val) {
                                      if (val == null || val.length < 6) {
                                        return "Password must be at least 6 characters";
                                      }
                                      return null;
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () =>
                                          context.push('/admin/reset_password'),
                                      child: Text(
                                        s.forgot_password,
                                        style: const TextStyle(
                                          color: Color(0xff0186c7),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: state is SignLoadingState
                                        ? null
                                        : () => context.read<SignCubit>().login(
                                              context,
                                              _formKey,
                                              _emailController,
                                              _passwordController,
                                            ),
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
                                        ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text(
                                            s.loginPage,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        s.dont_have_account,
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            context.go('/admin/signup'),
                                        child: Text(
                                          s.register_now,
                                          style: const TextStyle(
                                            color: Color(0xff0186c7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      enabled: true,
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.grey),
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
