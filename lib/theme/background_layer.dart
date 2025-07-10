import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteos_app/theme/theme.dart';

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({
    super.key,
    this.drawer,
    this.bottomNavigationBar,
    this.child,
    this.floatingActionButton,
    this.appBar,
    this.floatingActionButtonLocation,
    this.extendBodyBehindAppBar = false,
  });

  /// Nuevo: cajón de navegación
  final Widget? drawer;

  /// Nuevo: barra inferior de navegación
  final Widget? bottomNavigationBar;

  final Widget? child;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBodyBehindAppBar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: MaterialTheme.greenColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        clipBehavior: Clip.none,

        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: Offset(-134.r, -134.r),
              child: Container(
                width: 268.r,
                height: 268.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: MaterialTheme.whiteColor.withValues(alpha: .2),
                      blurRadius: 134.r,
                      spreadRadius: 24.r,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Transform.translate(
              offset: Offset(164.r, 0),
              child: Container(
                width: 268.r,
                height: 268.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: MaterialTheme.otherColor2.withValues(alpha: .2),
                      blurRadius: 134.r,
                      spreadRadius: 24.r,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Transform.translate(
              offset: Offset(-134.r, 134.r),
              child: Container(
                width: 268.r,
                height: 268.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: MaterialTheme.whiteColor.withValues(alpha: .2),
                      blurRadius: 134.r,
                      spreadRadius: 24.r,
                    ),
                  ],
                ),
              ),
            ),
          ),
          child ?? const SizedBox(),
        ],
      ),
    );
  }
}
