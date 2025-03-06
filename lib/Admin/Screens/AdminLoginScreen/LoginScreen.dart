import 'package:ajeal/Admin/Screens/AdminLoginScreen/ResetPasswordScreen.dart';
import 'package:ajeal/Admin/Screens/AdminLoginScreen/SignUpScreen.dart';
import 'package:ajeal/Admin/Screens/AdminLoginScreen/cubit/sign_cubit.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AdminLoginScreen extends StatelessWidget {
  AdminLoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    return BlocProvider(
  create: (context) => SignCubit(),
  child: BlocListener<SignCubit, SignState>(

      listener: (context, state) {

        if (state is SignFaliureState) {
          Get.snackbar(
            "Error",
            state.error,
            backgroundColor: Colors.red.withOpacity(0.9),
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
          );
        }

      },
      child: Scaffold(
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

            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo Section
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
                    // Welcome Text
                    Text(
                      S.of(context).letsSignIn,
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

                    const SizedBox(height: 32),

                    // Login Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          _buildTextField(
                            controller: _emailController,
                            label: "Email",
                            icon: Icons.email_outlined,
                            validator: (val) {
                              if (!val!.isEmail) {
                                return "Please enter a valid email";
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
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ResetPasswordScreen()),
                              ),
                              child:  Text(
                               S.of(context).forgot_password,
                                style: const TextStyle(
                                  color: Color(0xff0186c7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Login Button
                          BlocBuilder<SignCubit, SignState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: state is SignLoadingState
                                    ? null
                                    : () => context.read<SignCubit>().Login(context, _formKey,
                                        _emailController, _passwordController),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff0186c7),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  minimumSize: Size(size.width, 0),
                                  elevation: 2,
                                ),
                                child: state is SignLoadingState
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    :  Text(
                                       S.of(context).loginPage,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).dont_have_account,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SignupScreen()),
                                ),
                                child:  Text(
                                  S.of(context).register_now,
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
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
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
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
