import 'package:flutter/material.dart';

class AppGradients {
  // Degradado principal (puedes ajustar colores y dirección)
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE91E63),
      Color(0xFFFFC107),
    ],
  );

  // Otro degradado, si lo necesitas
  static const LinearGradient secondary = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2196F3),
      Color(0xFF21CBF3),
    ],
  );
}
