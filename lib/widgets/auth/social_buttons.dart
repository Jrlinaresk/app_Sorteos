import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButtons extends StatelessWidget {
  final void Function(String provider) onTap;
  const SocialButtons({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final icons = {
      'facebook': 'assets/svg/facebook.svg',
      'google': 'assets/svg/google.svg',
      'linkedin': 'assets/svg/linkedin.svg',
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          icons.entries.map((e) {
            return IconButton(
              icon: SvgPicture.asset(e.value, width: 32, height: 32),
              onPressed: () => onTap(e.key),
            );
          }).toList(),
    );
  }
}
