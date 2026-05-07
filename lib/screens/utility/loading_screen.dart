import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/theme/theme.dart';

/// Pantalla de carga full‑screen. Devuelve `true` si el usuario pulsó atrás.
class LoadingScreen extends StatelessWidget {
  final String message;
  final Widget? logo;
  const LoadingScreen({super.key, this.message = 'Cargando…', this.logo});
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
    return Navigator.of(context, rootNavigator: true)
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
    if (!_isShowing) return;

    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      _isShowing = false;
      navigator.pop(false);
      return;
    }

    // Si la ruta aún no terminó de insertarse, reintenta una vez.
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!_isShowing) return;
      final nav = Navigator.of(context, rootNavigator: true);
      if (nav.canPop()) {
        _isShowing = false;
        nav.pop(false);
      }
    });
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
        backgroundColor: MaterialTheme.greenColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (logo != null) ...[
                  SizedBox(width: 256.w, height: 256.w, child: logo),
                  SizedBox(height: 24.h),
                ],
                CircularProgressIndicator(color: MaterialTheme.whiteColor),
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
