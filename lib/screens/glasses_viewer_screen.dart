import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/glasses_controller.dart';
import 'components/viewer_background.dart';
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
          ViewerBackground(isTryOnMode: controller.isTryOnMode),

          // Main Interactive Layer
          const SafeArea(
            child: Column(
              children: [
                SizedBox(height: 16),

                // 3D Model Viewer — single active model
                Expanded(
                  child: ActiveModelViewer(),
                ),

                // Dynamic Metadata Layer
                ModelMetadata(),

                // Control Interface
                ViewerControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
