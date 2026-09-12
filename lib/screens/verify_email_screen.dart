import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  void resendVerificationEmail() {
    //  verification email Message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification link resent to your email.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
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
                      horizontal: isSmallWidth ? 14 : 24,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: const Color(0xFF91AEB1),
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // TITLE
                        Text(
                          'Verify your email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallWidth ? 24 : 28,
                            fontWeight: FontWeight.w700,
                            color: AppColor.primary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // SUBTITLE
                        const Text(
                          "We've sent a verification link to your email address. Please check your inbox and click the link to continue setting up your FinCorp Solutions account.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: AppColor.secondary,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // RESEND EMAIL BUTTON
                        CustomButton(
                          text: 'Resend Email',
                          onPressed: resendVerificationEmail,
                        ),

                        const SizedBox(height: 12),

                        // CHANGE EMAIL BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF91AEB1),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Change Email',
                              style: TextStyle(
                                color: AppColor.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // BACK TO LOGIN LINK
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                                  (route) => false,
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: AppColor.secondary,
                          ),
                          label: const Text(
                            'Back to Login',
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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