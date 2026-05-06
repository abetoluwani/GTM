import 'package:flutter/material.dart';
import '../models/glasses_model.dart';

class GlassesPainter3D extends StatelessWidget {
  final GlassesModel model;
  final double size;

  const GlassesPainter3D({
    super.key,
    required this.model,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.4),
      painter: _GlassesPainter(
        frameColor: model.frameColor,
        lensColor: model.lensColor,
      ),
    );
  }
}

class _GlassesPainter extends CustomPainter {
  final Color frameColor;
  final Color lensColor;

  _GlassesPainter({
    required this.frameColor,
    required this.lensColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final framePaint = Paint()
      ..color = frameColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final lensPaint = Paint()
      ..color = lensColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;
    final lensWidth = width * 0.35;
    final lensHeight = height * 0.7;

    // Left lens
    final leftLensRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(width * 0.25, height * 0.5),
        width: lensWidth,
        height: lensHeight,
      ),
      const Radius.circular(12),
    );

    // Right lens
    final rightLensRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(width * 0.75, height * 0.5),
        width: lensWidth,
        height: lensHeight,
      ),
      const Radius.circular(12),
    );

    // Draw lens fills
    canvas.drawRRect(leftLensRect, lensPaint);
    canvas.drawRRect(rightLensRect, lensPaint);

    // Draw lens highlights
    final highlightLeft = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        width * 0.15,
        height * 0.2,
        lensWidth * 0.4,
        lensHeight * 0.3,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(highlightLeft, highlightPaint);

    final highlightRight = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        width * 0.65,
        height * 0.2,
        lensWidth * 0.4,
        lensHeight * 0.3,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(highlightRight, highlightPaint);

    // Draw frames
    canvas.drawRRect(leftLensRect, framePaint);
    canvas.drawRRect(rightLensRect, framePaint);

    // Draw bridge
    final bridgePath = Path()
      ..moveTo(width * 0.42, height * 0.35)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.28,
        width * 0.58,
        height * 0.35,
      );
    canvas.drawPath(bridgePath, framePaint);

    // Draw temples (arms)
    final leftTemplePath = Path()
      ..moveTo(width * 0.08, height * 0.4)
      ..lineTo(width * 0.02, height * 0.35);
    canvas.drawPath(leftTemplePath, framePaint);

    final rightTemplePath = Path()
      ..moveTo(width * 0.92, height * 0.4)
      ..lineTo(width * 0.98, height * 0.35);
    canvas.drawPath(rightTemplePath, framePaint);

    // Draw temple hinges (dots)
    canvas.drawCircle(
      Offset(width * 0.08, height * 0.4),
      3,
      Paint()..color = frameColor,
    );
    canvas.drawCircle(
      Offset(width * 0.92, height * 0.4),
      3,
      Paint()..color = frameColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
