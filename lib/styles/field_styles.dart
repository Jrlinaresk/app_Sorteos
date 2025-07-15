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
    final focusedBorderColor = MaterialTheme.oranchColor.withValues(alpha: .6);

    return InputDecoration(
      alignLabelWithHint: false,
      hintText: hint,
      hintStyle: TextStyle(color: MaterialTheme.whiteColor, fontSize: 22.h),
      filled: true,
      fillColor:
          editable ? MaterialTheme.oranchColor : MaterialTheme.whiteColor,
      errorStyle:
          errorStyle ??
          TextStyle(
            fontSize: 12,
            color: MaterialTheme.pinkColor,
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
    final focusedBorderColor = MaterialTheme.oranchColor;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: MaterialTheme.pinkColor),
      filled: true,
      fillColor: enabled ? MaterialTheme.oranchColor : MaterialTheme.whiteColor,
      errorStyle:
          errorStyle ?? TextStyle(fontSize: 12, color: MaterialTheme.pinkColor),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.whiteColor, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.pinkColor, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: focusedBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.pinkColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MaterialTheme.pinkColor, width: 2),
      ),
    );
  }
}
