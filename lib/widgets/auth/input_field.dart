import 'package:flutter/material.dart';
import 'package:sorteos_app/theme/theme.dart';

class InputField extends StatelessWidget {
  final String hint;
  final bool obscure;
  const InputField({required this.hint, this.obscure = false, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: MaterialTheme.redColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
