import 'package:expense_tracker/screens/verify_email_screen.dart';
import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/custome_text_field.dart';
import '../widgets/field_label.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void resetPassword() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset successfully!'),
      ),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Gray_palette.gray1,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // FORM CONTENT
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //top spacing
                          const SizedBox(height: 170),

                          // TITLE
                          const Text(
                            'Reset Password?',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Gray_palette.gray12,
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // SUBTITLE
                          const Text(
                            'Enter your new password below',
                            style: TextStyle(
                              fontSize: 14,
                              color: Gray_palette.gray10,
                            ),
                          ),

                          const SizedBox(height: 75),

                          //PASSWORD FIELD
                          const FieldLabel(text: 'Password', isRequired: true),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: passwordController,
                            hintText: 'Set Strong Password',
                            prefixIcon: Icons.vpn_key_outlined,
                            obscureText: obscurePassword,
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

                          const SizedBox(height: 22),

                          // CONFIRM PASSWORD FIELD
                          const FieldLabel(
                              text: 'Confirm Password', isRequired: true),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm Password',
                            prefixIcon: Icons.vpn_key_outlined,
                            obscureText: obscureConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 75),

                          // RESET PASSWORD BUTTON
                          CustomButton(
                            text: 'Reset Password',
                            onPressed: resetPassword,
                          ),

                          const SizedBox(height: 20),

                          // BACK TO LOGIN LINK
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                              child: const Text(
                                'Back To Login',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: BrandColor.brand5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  // MOUNTAIN VECTOR BANNER
                  Image.asset(
                    'assets/images/mountain_banner.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}