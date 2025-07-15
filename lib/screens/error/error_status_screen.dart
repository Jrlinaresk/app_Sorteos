// lib/screens/payment/transaction_error_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/enums/enums.dart';
import 'package:sorteos_app/theme/theme.dart';

class ErrorStatusScreen extends StatelessWidget {
  final TxStatus status;
  final String userId;
  const ErrorStatusScreen({
    super.key,
    required this.status,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final isInsuf = status == TxStatus.insufficientFunds;
    final icon = isInsuf ? Icons.error_outline : Icons.warning;
    final title = isInsuf ? 'Saldo insuficiente' : 'Algo salió mal';
    final message =
        isInsuf
            ? 'No tienes saldo suficiente.\nHaz clic en el botón para recargar tu cuenta.'
            : 'Ocurrió un error del servidor.\nInténtalo más tarde.';
    final buttonLabel = isInsuf ? 'Recargar saldo' : 'Reintentar';

    return Scaffold(
      backgroundColor: MaterialTheme.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 64.h),

                  Icon(
                    icon,
                    size: 100.w,
                    color: isInsuf ? Colors.red : Colors.orange,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: isInsuf ? Colors.red : Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    message,
                    style: TextStyle(fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (isInsuf) {
                      context.goNamed('recharge', extra: {'userId': userId});
                    } else {
                      context
                          .pop(); // vuelve a pantalla anterior para reintentar
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // Text & icon color
                    foregroundColor: MaterialTheme.greenColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: MaterialTheme.whiteColor,
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      buttonLabel,
                      style: TextStyle(color: MaterialTheme.greenColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
