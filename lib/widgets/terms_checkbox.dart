import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            activeColor: const Color(0xFF004F57),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            side: const BorderSide(
              color: Color(0xFFB8C4C6),
            ),
            onChanged: onChanged,
          ),
        ),

        const SizedBox(width: 4),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Wrap(
              children: [
                const Text(
                  'I agree to the ',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Color(0xFF50595B),
                  ),
                ),

                GestureDetector(
                  onTap: onTermsTap,
                  child: const Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: Color(0xFF004F57),
                    ),
                  ),
                ),

                const Text(
                  ' and ',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Color(0xFF50595B),
                  ),
                ),

                GestureDetector(
                  onTap: onPrivacyTap,
                  child: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: Color(0xFF004F57),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}