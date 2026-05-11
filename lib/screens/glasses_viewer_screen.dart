import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/glasses_controller.dart';
import '../widgets/try_on_view.dart';
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: controller.isTryOnMode
            ? _TryOnLayout(key: const ValueKey('tryOn'))
            : _ViewerLayout(key: const ValueKey('viewer')),
      ),
    );
  }
}

/// Layout for the standard 3D model viewer mode.
class _ViewerLayout extends StatelessWidget {
  const _ViewerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: const [
          SizedBox(height: 16),
          Expanded(child: ActiveModelViewer()),
          ModelMetadata(),
          ViewerControls(),
        ],
      ),
    );
  }
}

/// Layout for the immersive try-on mode.
/// The TryOnView fills the entire screen with the "View 3D" button
/// floating at the bottom.
class _TryOnLayout extends StatelessWidget {
  const _TryOnLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const TryOnView(),
        // Floating control at the bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            child: const ViewerControls(),
          ),
        ),
      ],
    );
  }
}
