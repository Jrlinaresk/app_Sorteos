// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 64.w, color: Colors.redAccent),
            SizedBox(height: 16.h),
            Text('Aquí irán tus favoritos', style: TextStyle(fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }
}
