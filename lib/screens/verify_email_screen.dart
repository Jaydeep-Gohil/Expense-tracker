import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../widgets/custom_buttom.dart';
import 'package:open_mail_launcher/open_mail_launcher.dart';

class VerifyEmailScreen extends StatelessWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  Future<void> openEmailApp() async {

    await OpenMailLauncher.openMailApp();
  }


  void resendEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification link resent to your email.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // MAIN CONTENT
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Top spacing
                        const SizedBox(height: 170),

                        // TITLE
                        const Text(
                          'Verify Your Email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // EMAIL
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "We've sent a verification link to\n",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColor.secondary,
                              height: 1.45,
                            ),
                            children: [
                              TextSpan(
                                text: '$email.\n',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const TextSpan(
                                text:
                                'Please check your inbox and click\nthe link to continue.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 75),

                        // OPEN EMAIL APP BUTTON
                        CustomButton(
                          text: 'Open Email App',
                          onPressed: openEmailApp,
                        ),

                        const SizedBox(height: 20),

                        // RESEND EMAIL LINK
                        GestureDetector(
                          onTap: () => resendEmail(context),
                          child: const Text(
                            'Resend Email',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColor.accent,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // MOUNTAIN BANNER
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