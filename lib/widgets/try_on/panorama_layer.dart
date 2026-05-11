import 'dart:math' as math;
import 'package:flutter/material.dart';

class PanoramaLayer extends StatelessWidget {
  const PanoramaLayer({
    super.key,
    required this.breathController,
    required this.offsetX,
    required this.offsetY,
    required this.environmentImage,
  });

  final AnimationController breathController;
  final double offsetX;
  final double offsetY;
  final String environmentImage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imgW = size.width * 3.0;
    final imgH = size.height * 1.5;

    return ClipRect(
      child: AnimatedBuilder(
        animation: breathController,
        builder: (context, child) {
          final drift = math.sin(breathController.value * math.pi * 2) * 4.0;
          return OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(offsetX + drift, offsetY),
              child: child,
            ),
          );
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          child: Image.network(
            environmentImage,
            key: ValueKey(environmentImage),
            width: imgW,
            height: imgH,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              final total = loadingProgress.expectedTotalBytes;
              final loaded = loadingProgress.cumulativeBytesLoaded;
              final progress = total != null ? loaded / total : null;
              return SizedBox(
                width: imgW,
                height: imgH,
                child: Center(
                  child: CircularProgressIndicator(
                    value: progress,
                    color: Colors.white24,
                    strokeWidth: 2,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => SizedBox(
              width: imgW,
              height: imgH,
              child: const Center(
                child: Icon(
                  Icons.landscape_rounded,
                  size: 80,
                  color: Colors.white24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
