import 'package:flutter/material.dart';

class LensTintOverlay extends StatelessWidget {
  const LensTintOverlay({super.key, required this.lensColor});

  final Color lensColor;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.3,
            colors: [
              lensColor.withValues(alpha: 0.18),
              lensColor.withValues(alpha: 0.40),
            ],
            stops: const [0.35, 1.0],
          ),
        ),
      ),
    );
  }
}
