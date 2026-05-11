import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class PanoramaLayer extends StatelessWidget {
  const PanoramaLayer({
    super.key,
    required this.breathController,
    required this.environmentImage,
    
  });

  final AnimationController breathController;
  final String environmentImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: breathController,
      builder: (context, child) {
        // We can still use the breath controller to simulate slight head movement
        // by wrapping the panorama in a subtle transform or just let it be.
        return child!;
      },
      child: PanoramaViewer(
        animSpeed: 0.1, // Slow rotation for ambient feel
        sensorControl: SensorControl.orientation, // Allows looking around by moving the phone
        child: Image.asset(
          environmentImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFF1A1A2E),
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
    );
  }
}
