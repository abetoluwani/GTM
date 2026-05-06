import 'package:flutter/material.dart';

class ARBackgroundView extends StatelessWidget {
  const ARBackgroundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[300]!, Colors.grey[400]!, Colors.grey[500]!],
        ),
      ),
      child: Stack(
        children: [
          // City buildings silhouette
          Positioned.fill(child: CustomPaint(painter: _CityScapePainter())),

          // Street and elements
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: CustomPaint(painter: _StreetScapePainter()),
          ),
        ],
      ),
    );
  }
}

class _CityScapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final buildingPaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.fill;

    final windowPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.fill;

    // Left building cluster
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.15, size.width * 0.25, size.height),
      buildingPaint,
    );

    // Windows for left building
    for (var i = 0; i < 10; i++) {
      for (var j = 0; j < 4; j++) {
        canvas.drawRect(
          Rect.fromLTWH(
            j * 30.0 + 10,
            size.height * 0.15 + i * 40.0 + 20,
            20,
            25,
          ),
          windowPaint,
        );
      }
    }

    // Center tall building
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.35,
        size.height * 0.05,
        size.width * 0.15,
        size.height,
      ),
      buildingPaint,
    );

    // Right building
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.7,
        size.height * 0.1,
        size.width * 0.3,
        size.height,
      ),
      buildingPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StreetScapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final streetPaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Street
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.6),
      streetPaint,
    );

    // Crosswalk lines
    for (var i = 0; i < 10; i++) {
      canvas.drawRect(
        Rect.fromLTWH(size.width * 0.3 + i * 40.0, size.height * 0.55, 30, 8),
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
