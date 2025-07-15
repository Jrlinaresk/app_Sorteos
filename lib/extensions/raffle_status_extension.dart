// lib/extensions/raffle_status_extension.dart

import 'package:flutter/material.dart';

extension RaffleStatusExtension on String {
  /// Etiqueta legible
  String get label {
    switch (this) {
      case 'closed':
        return 'Finalizada';
      case 'cancelled':
        return 'Cancelada';
      case 'open':
      default:
        return 'Abierta';
    }
  }

  /// Color de fondo de la cápsula
  Color get backgroundColor {
    switch (this) {
      case 'closed':
        return const Color.fromARGB(
          255,
          247,
          247,
          247,
        ); // verde pastel muy claro 0xFFDFF7DF
      case 'cancelled':
        return const Color(0xFFFFE5E5); // rojo pastel muy claro 0xFFFFE5E5
      case 'open':
      default:
        return const Color.fromARGB(
          255,
          255,
          255,
          255,
        ); // verde pastel muy claro 0xFFDFF7DF
    }
  }

  /// Color del texto / icono
  Color get textColor {
    switch (this) {
      case 'closed':
        return const Color.fromARGB(255, 6, 0, 30); // verde oscuro 0xFFC62828
      case 'cancelled':
        return const Color(0xFFC62828); // rojo oscuro
      case 'open':
      default:
        return const Color(0xFF2E7D32); // amarillo oscuro 0xFFF9A825
    }
  }
}
