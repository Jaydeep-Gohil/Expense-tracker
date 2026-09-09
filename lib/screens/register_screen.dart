import 'package:expense_tracker/widgets/custom_text_field.dart';
import 'package:expense_tracker/widgets/field_label.dart';
import 'package:flutter/material.dart';

import '../widgets/currency_dropdown.dart';
import '../widgets/terms_checkbox.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool termsAccepted = false;

  String selectedCurrency = 'USD (\$)';

  final List<String> currencies = [
    'USD (\$)',
    'INR (₹)',
    'EUR (€)',
    'GBP (£)',
    'AED (د.إ)',
  ];

  void createAccount() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the Terms of Service and Privacy Policy.',
          ),
        ),
      );
      return;
    }

    // Connect registration API / Supabase here.

    debugPrint('Name: ${fullNameController.text}');
    debugPrint('Email: ${emailController.text}');
    debugPrint('Currency: $selectedCurrency');
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                          // Dynamic space at top
                          const Spacer(flex: 1),

                          // TITLE
                          Center(
                            child: Text(
                              'Create Account',
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
                              'Join FinCorp Solutions today.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF50595B),
                              ),
                            ),
                          ),

                          const Spacer(flex: 1),

                          // FULL NAME
                          const FieldLabel(text: 'Full Name'),
                          const SizedBox(height: 4),
                          CustomTextField(
                            controller: fullNameController,
                            hintText: 'Shree Ram',
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),

                          const Spacer(flex: 1),

                          // EMAIL
                          const FieldLabel(text: 'Email Address'),
                          const SizedBox(height: 4),
                          CustomTextField(
                            controller: emailController,
                            hintText: 'shree.ram@example.com',
                            prefixIcon: Icons.email,
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

                          const Spacer(flex: 1),

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

                          const Spacer(flex: 1),

                          // CONFIRM PASSWORD
                          const FieldLabel(text: 'Confirm Password'),
                          const SizedBox(height: 4),
                          CustomTextField(
                            controller: confirmPasswordController,
                            hintText: '••••••••',
                            prefixIcon: Icons.lock_reset_outlined,
                            obscureText: obscureConfirmPassword,
                            onToggleVisibility: () {
                              setState(() {
                                obscureConfirmPassword =
                                    !obscureConfirmPassword;
                              });
                            },
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

                          const Spacer(flex: 1),

                          // CURRENCY (Duplicates removed)
                          const FieldLabel(text: 'Primary Currency'),
                          const SizedBox(height: 4),
                          CurrencyDropdown(
                            selectedCurrency: selectedCurrency,
                            currencies: currencies,
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                selectedCurrency = value;
                              });
                            },
                          ),

                          const Spacer(flex: 1),

                          // TERMS
                          TermsCheckbox(
                            value: termsAccepted,
                            onChanged: (value) {
                              setState(() {
                                termsAccepted = value ?? false;
                              });
                            },
                            onTermsTap: () {},
                            onPrivacyTap: () {},
                          ),

                          const Spacer(flex: 1),

                          // CREATE ACCOUNT BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: createAccount,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003D46),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const Spacer(flex: 1),

                          // SIGN IN
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF50595B),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Sign In',
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
