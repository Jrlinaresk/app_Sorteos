import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/theme/theme.dart';

class FieldStyles {
  /// Decoración base para todos los TextField/ TextFormField de la app
  static InputDecoration base({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool editable = true,
    TextStyle? errorStyle,
  }) {
    final focusedBorderColor = MaterialTheme.otherColor2.withValues(alpha: .6);

    return InputDecoration(
      alignLabelWithHint: false,
      hintText: hint,
      hintStyle: TextStyle(color: MaterialTheme.whiteColor, fontSize: 22.h),
      filled: true,
      fillColor:
          editable ? MaterialTheme.otherColor2 : MaterialTheme.whiteColor,
      errorStyle:
          errorStyle ??
          TextStyle(
            fontSize: 12,
            color: MaterialTheme.otherColor,
            fontWeight: FontWeight.w500,
          ),
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16, // espacio arriba y abajo
        horizontal: 24, // espacio a izquierda y derecha
      ),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), // muy redondo
        borderSide: BorderSide(
          color: MaterialTheme.whiteColor,
          width: 0.5, // grosor del borde
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.whiteColor, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: focusedBorderColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.whiteColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.whiteColor, width: 2),
      ),
    );
  }

  /// Decoración para DropdownButtonFormField
  static InputDecoration dropdown({
    String? label,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
    TextStyle? errorStyle,
  }) {
    final focusedBorderColor = MaterialTheme.otherColor2;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: MaterialTheme.otherColor),
      filled: true,
      fillColor: enabled ? MaterialTheme.otherColor2 : MaterialTheme.whiteColor,
      errorStyle:
          errorStyle ??
          TextStyle(fontSize: 12, color: MaterialTheme.otherColor),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.whiteColor, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.otherColor, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: focusedBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.otherColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.otherColor, width: 2),
      ),
    );
  }
}
