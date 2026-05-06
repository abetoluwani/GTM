import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../controllers/glasses_controller.dart';

class ARBackgroundView extends StatelessWidget {
  const ARBackgroundView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GlassesController>();
    final model = controller.currentModel;
    
    // The "World" environment model (City/Street)
    const worldUrl = 'https://cdn.jsdelivr.net/gh/KhronosGroup/glTF-Sample-Assets@main/Models/EnvironmentTest/glTF-Binary/EnvironmentTest.glb';

    return Stack(
      children: [
        // 1. The 3D World
        ModelViewer(
          key: const ValueKey('world_viewer'),
          src: worldUrl,
          backgroundColor: Colors.black,
          autoRotate: false,
          cameraControls: true,
          disableZoom: false,
          interactionPrompt: InteractionPrompt.none,
          // Low exposure to make the lens tint pop
          exposure: 0.8,
        ),

        // 2. The Lens Tint Overlay
        // This simulates looking through the colored glass
        IgnorePointer(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: model.lensColor.withValues(alpha: 0.4),
              // Subtle vignette to simulate lens edges
              gradient: RadialGradient(
                colors: [
                  model.lensColor.withValues(alpha: 0.2),
                  model.lensColor.withValues(alpha: 0.6),
                ],
                stops: const [0.7, 1.0],
              ),
            ),
          ),
        ),
        
        // 3. Optional: A subtle "frame" blur at the edges
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.3),
                width: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
