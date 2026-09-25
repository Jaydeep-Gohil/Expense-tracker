import 'package:expense_tracker/constants/color.dart';
import 'package:flutter/material.dart';


class CustomDropdownField<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final Widget? prefixWidget;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      icon: const Padding(
        padding: EdgeInsets.only(right: 12),
        child: Icon(
          Icons.keyboard_arrow_down,
          color: BrandColor.brand1,
          size: 18,
        ),
      ),
      dropdownColor: Colors.white,
      style: const TextStyle(
        fontSize: 14,
        color: BrandColor.brand1,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixWidget != null
            ? Padding(
          padding: const EdgeInsets.only(left: 18, right: 10),
          child: prefixWidget,
        )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 20,
        ),
        filled: true,
        fillColor: Gray_palette.gray1,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Gray_palette.gray4,
            width: 1,
          ),
        ),
      ),
    );
  }
}