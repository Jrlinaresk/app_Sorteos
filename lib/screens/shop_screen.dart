// lib/screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tienda', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 64.w, color: Colors.green),
            SizedBox(height: 16.h),
            Text('Bienvenido a la tienda', style: TextStyle(fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }
}
