import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 48,
    this.radius = 16,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(6),
  });

  final double size;
  final double radius;
  final Color? backgroundColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 4),
        child: Image.asset(
          'assets/images/app_logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
