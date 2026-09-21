import 'package:flutter/material.dart';
import '../constants/color.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const FieldLabel({
    super.key,
    required this.text,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColor.label,
        ),
        children: isRequired
            ? const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: AppColor.requiredStar,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]
            : [],
      ),
    );
  }
}