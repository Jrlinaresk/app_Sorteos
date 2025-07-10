import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Define aquí el tamaño base de tu diseño (p. ej. 360×690)
      designSize: const Size(360, 690),
      builder: (context, child) {
        return ProviderScope(
          child: MaterialApp.router(
            title: 'Rifas App',
            routerConfig: router,
            // Opcionales: tema, localización, etc.
          ),
        );
      },
    );
  }
}
