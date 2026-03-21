import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackground,
                  const Color(0xFF1A1A3E),
                  AppColors.darkBackground,
                ]
              : [
                  AppColors.lightBackground,
                  const Color(0xFFE8EAF6),
                  AppColors.lightBackground,
                ],
        ),
      ),
      child: child,
    );
  }
}
