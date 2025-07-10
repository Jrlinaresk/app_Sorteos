import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/enums/enums.dart';
import 'package:sorteos_app/theme/theme.dart';

class AppSnackbar {
  static void showSnackbar(
    BuildContext context,
    String title,
    String message,
    TypeSnackBar type,
  ) {
    final Color background;
    switch (type) {
      case TypeSnackBar.success:
        background = MaterialTheme.dialogInfoColor;
        break;
      case TypeSnackBar.warning:
        background = MaterialTheme.dialogWarningColor;
        break;
      case TypeSnackBar.error:
        background = MaterialTheme.dialogErrorColor;
        break;
    }

    final snack = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 5),
      backgroundColor: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(
          color: MaterialTheme.whiteColor.withOpacity(.2),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      content: Column(
        mainAxisSize: MainAxisSize.min, // deja crecer en vertical
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primera línea: icono, título y botón de cerrar
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: MaterialTheme.whiteColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: MaterialTheme.whiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap:
                    () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: Icon(
                  Icons.close,
                  color: MaterialTheme.whiteColor,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Segunda línea: el mensaje completo, deja salto de línea
          Text(
            message,
            style: TextStyle(color: MaterialTheme.whiteColor, fontSize: 14.sp),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snack);
  }
}
