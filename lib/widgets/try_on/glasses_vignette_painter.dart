import 'package:flutter/material.dart';

class GlassesVignettePainter extends CustomPainter {
  GlassesVignettePainter({required this.frameColor});

  final Color frameColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Soft radial vignette — subtle darkening toward edges
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.95,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.15),
          Colors.black.withValues(alpha: 0.50),
        ],
        stops: const [0.5, 0.8, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, vignettePaint);

    // Nose bridge shadow
    final noseRect = Rect.fromLTWH(
      size.width * 0.42,
      size.height * 0.88,
      size.width * 0.16,
      size.height * 0.12,
    );
    final nosePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.25),
        ],
      ).createShader(noseRect);
    canvas.drawRect(noseRect, nosePaint);
  }

  @override
  bool shouldRepaint(GlassesVignettePainter old) =>
      old.frameColor != frameColor;
}
