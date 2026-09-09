import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final String selectedCurrency;
  final List<String> currencies;
  final ValueChanged<String?> onChanged;

  const CurrencyDropdown({
    super.key,
    required this.selectedCurrency,
    required this.currencies,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFB8C4C6),
          width: 0.8,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCurrency,
          isExpanded: true,
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF738083),
          ),
          items: currencies.map((currency) {
            return DropdownMenuItem<String>(
              value: currency,
              child: Row(
                children: [
                  const Icon(
                    Icons.payments_outlined,
                    size: 20,
                    color: Color(0xFF738083),
                  ),
                  const SizedBox(width: 9),
                  Text(
                    currency,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF263238),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}