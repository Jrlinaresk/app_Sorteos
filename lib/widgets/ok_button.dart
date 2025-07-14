import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/theme/theme.dart';

class OkButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final VoidCallback onPressed;
  final String? iconData;
  final bool enabled; // ← Nuevo parámetro

  const OkButton({
    super.key,
    required this.title,
    required this.isLoading,
    required this.onPressed,
    this.iconData = "assets/icons/arrow-narrow-right.png",
    this.enabled = true, // ← Por defecto habilitado
  });

  @override
  Widget build(BuildContext context) {
    // Elegimos el degradado según el estado enabled
    final gradientColors =
        enabled
            ? [
              MaterialTheme.greenColor.withValues(alpha: .8),
              MaterialTheme.greenColor.withValues(alpha: .1),
            ]
            : [
              const Color.fromARGB(255, 172, 172, 172),
              const Color.fromARGB(255, 46, 46, 46),
            ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            height: 59,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: (enabled && !isLoading) ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child:
                    isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Esto crea espacio a la izquierda igual al icono,
                            // para que el texto quede perfectamente centrado
                            const SizedBox(width: 12),
                            // Texto centrado
                            Expanded(
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            // Icono pegado al borde derecho
                            SizedBox(
                              width: 32,
                              child: Center(
                                child: Image.asset(
                                  iconData!,
                                  width: 64.sp,
                                  height: 64.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
