// lib/screens/payment/transaction_complete_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/theme/theme.dart';

class TransactionCompleteScreen extends StatelessWidget {
  const TransactionCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MaterialTheme.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 100.w, color: Colors.green),
              SizedBox(height: 24.h),
              Text(
                '¡Felicidades!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: MaterialTheme.greenColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'Ahora podras ser uno de los ganadores',
                style: TextStyle(fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: () => context.goNamed('home'),
                style: ElevatedButton.styleFrom(
                  // Text & icon color
                  foregroundColor: MaterialTheme.greenColor,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  backgroundColor: MaterialTheme.whiteColor,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  minimumSize: Size(double.infinity, 48.h),
                ),
                child: Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
