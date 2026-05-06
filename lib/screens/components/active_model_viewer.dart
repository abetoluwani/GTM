import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../../controllers/glasses_controller.dart';

class ActiveModelViewer extends StatelessWidget {
  const ActiveModelViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GlassesController>();
    final model = controller.currentModel;
    final isTryOnMode = controller.isTryOnMode;
    final isTransitioning = controller.isTransitioning;

    return AnimatedOpacity(
      opacity: isTransitioning ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Center(
        child: ModelViewer(
          // We use a key that includes the index so the script re-runs,
          // but the src remains the same so the browser cache makes it instant.
          key: ValueKey('viewer_${controller.currentIndex}'),
          backgroundColor: Colors.transparent,
          src: model.modelUrl!,
          alt: model.name,
          autoRotate: !isTryOnMode,
          autoRotateDelay: 0,
          cameraControls: true,
          disableZoom: true,
          loading: Loading.eager,
          touchAction: TouchAction.none, // Full rotation control
          interactionPrompt: InteractionPrompt.none,
          relatedJs: model.materialJs,
          relatedCss: '''
            :focus { outline: none; }
            model-viewer {
              --progress-bar-color: transparent;
              user-select: none;
              -webkit-tap-highlight-color: transparent;
            }
          ''',
        ),
      ),
    );
  }
}
