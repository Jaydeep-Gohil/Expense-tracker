import 'package:expense_tracker/screens/register_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/field_label.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  void handleLogin() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    debugPrint('Email: ${emailController.text}');
    debugPrint('Password: ${passwordController.text}');
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final isSmallHeight = height < 700;
            final isSmallWidth = width < 360;

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallWidth ? 14 : 18,
                      vertical: isSmallHeight ? 12 : 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: const Color(0xFF91AEB1),
                        width: 0.8,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(flex: 1),

                          // TITLE
                          Center(
                            child: Text(
                              'Welcome Back',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallWidth ? 24 : 28,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF003D46),
                              ),
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Center(
                            child: Text(
                              'Sign in to access your financial dashboard.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF50595B),
                              ),
                            ),
                          ),

                          const SizedBox(height: 50,),

                          // EMAIL
                          const FieldLabel(text: 'Email Address'),
                          const SizedBox(height: 4),
                          CustomTextField(
                            controller: emailController,
                            hintText: 'shree.ram@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // PASSWORD
                          const FieldLabel(text: 'Password'),
                          const SizedBox(height: 4),
                          CustomTextField(
                            controller: passwordController,
                            hintText: '••••••••',
                            prefixIcon: Icons.lock_outline,
                            obscureText: obscurePassword,
                            onToggleVisibility: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // SIGN IN BUTTON
                          CustomButton(
                            text: 'Sign In',
                            onPressed: handleLogin,
                          ),

                          const  SizedBox(height: 35),

                          // REGISTER REDIRECT
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF50595B),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF004F57),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}