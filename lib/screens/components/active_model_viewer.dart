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

     final double targetOpacity = (isTransitioning || isTryOnMode) ? 0.0 : 1.0;

    return AnimatedOpacity(
      opacity: targetOpacity,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Center(
        child: ModelViewer(
           key: ValueKey('viewer_${model.name}'),
          backgroundColor: Colors.transparent,
          src: model.modelUrl!,
          alt: model.name,
          autoRotate: !isTryOnMode,
          autoRotateDelay: 0,
          cameraControls: true,
          disableZoom: true,
          loading: Loading.eager,
          touchAction: TouchAction.none,
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
