// lib/screens/exit_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Pantalla fullscreen que pregunta “¿Seguro que deseas salir?”
/// Devuelve `true` si el usuario confirma la salida (o pulsa atrás otra vez),
/// `false` si cancela.
class ExitConfirmationScreen extends StatelessWidget {
  const ExitConfirmationScreen({super.key});

  /// Lanza el fullscreen y retorna Future<bool> indicando si el usuario
  /// confirmó salir.
  static Future<bool> show(BuildContext context) {
    return Navigator.of(context)
        .push<bool>(
          PageRouteBuilder(
            opaque: false,
            barrierColor: Colors.black54,
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (_, __, ___) => const ExitConfirmationScreen(),
          ),
        )
        .then((v) => v ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Si vuelve a pulsar atrás, consideramos confirmación
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: SafeArea(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(24.w),
              margin: EdgeInsets.symmetric(horizontal: 32.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.exit_to_app, size: 48.w, color: Colors.redAccent),
                  SizedBox(height: 16.h),
                  Text(
                    '¿Estás seguro que deseas salir?',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'Salir',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
