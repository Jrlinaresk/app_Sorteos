import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Pantalla de carga full‑screen. Devuelve `true` si el usuario pulsó atrás.
class LoadingScreen extends StatelessWidget {
  final String message;
  final Widget? logo;
  const LoadingScreen({Key? key, this.message = 'Cargando…', this.logo})
    : super(key: key);
  static bool _isShowing = false;

  /// Muestra la pantalla de carga.
  /// Retorna un Future<bool> que será `true` si el usuario pulsó atrás.
  static Future<bool> show(
    BuildContext context, {
    String message = 'Cargando…',
    Widget? logo,
  }) {
    if (_isShowing) return Future.value(false);
    _isShowing = true;
    return Navigator.of(context)
        .push<bool>(
          PageRouteBuilder(
            opaque: true,
            barrierColor: const Color.fromARGB(232, 0, 0, 0),
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            pageBuilder:
                (_, __, ___) => LoadingScreen(message: message, logo: logo),
          ),
        )
        .then((v) {
          _isShowing = false;
          return v ?? false;
        });
  }

  /// Cierra la pantalla de carga *solo si está activa*.
  static void hide(BuildContext context) {
    if (_isShowing && Navigator.canPop(context)) {
      _isShowing = false;
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Si el usuario pulsa “atrás”, devolvemos `true` y cerramos
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(240, 0, 0, 0),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (logo != null) ...[
                  SizedBox(width: 100.w, height: 100.w, child: logo),
                  SizedBox(height: 24.h),
                ],
                const CircularProgressIndicator(),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
