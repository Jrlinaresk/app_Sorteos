import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/theme.dart';

/// A reusable, customizable TabBar widget
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.onTap,
  });

  /// Controller to manage tab selection
  final TabController controller;

  /// List of Tab items (text or icon+text)
  final List<Widget> tabs;

  /// Optional callback when a tab is tapped
  final ValueChanged<int>? onTap;

  @override
  Size get preferredSize => Size.fromHeight(32.h);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      onTap: onTap,
      // Active/inactive label colors
      labelColor: MaterialTheme.whiteColor,
      unselectedLabelColor: MaterialTheme.whiteColor.withOpacity(0.7),

      // Font styles
      labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
      ),

      // Indicator style
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: MaterialTheme.whiteColor ?? MaterialTheme.redColor,
          width: 3.h,
        ),
        insets: EdgeInsets.symmetric(horizontal: 24.w),
      ),

      tabs: tabs,
    );
  }
}
