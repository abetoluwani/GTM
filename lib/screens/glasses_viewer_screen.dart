import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/glasses_controller.dart';
import '../widgets/ar_background_view.dart';
import 'components/active_model_viewer.dart';
import 'components/model_metadata.dart';
import 'components/viewer_controls.dart';

class GlassesViewerScreen extends StatelessWidget {
  const GlassesViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GlassesController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (controller.isTryOnMode)
            Positioned.fill(child: const ARBackgroundView()),
            
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: controller.isTryOnMode
                      ? const SizedBox.shrink()
                      : const ActiveModelViewer(),
                ),
                if (!controller.isTryOnMode) const ModelMetadata(),
                const ViewerControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
