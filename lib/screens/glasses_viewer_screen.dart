import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../controllers/glasses_controller.dart';
import '../widgets/ar_background_view.dart';
import '../widgets/sleek_buttons.dart';

class GlassesViewerScreen extends StatelessWidget {
  const GlassesViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GlassesController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _ViewerBackground(isTryOnMode: controller.isTryOnMode),

          // Main Interactive Layer
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Carousel Area - Decoupled Viewport
                const Expanded(
                  child: _GlassesCarousel(),
                ),

                // Dynamic Metadata Layer
                const _ModelMetadata(),

                // Control Interface
                const _ViewerControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewerBackground extends StatelessWidget {
  final bool isTryOnMode;

  const _ViewerBackground({required this.isTryOnMode});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: isTryOnMode
          ? const ARBackgroundView(key: ValueKey('ar'))
          : const SizedBox.shrink(key: ValueKey('dark')),
    );
  }
}

class _GlassesCarousel extends StatelessWidget {
  const _GlassesCarousel();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GlassesController>();
    final glassesList = controller.glassesList;

    return PageView.builder(
      controller: controller.pageController,
      onPageChanged: controller.updateIndex,
      itemCount: glassesList.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: controller.pageController,
          builder: (context, child) {
            double value = 1.0;
            if (controller.pageController.position.haveDimensions) {
              value = controller.pageController.page! - index;
              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
            } else {
              if (index != controller.currentIndex) value = 0.7;
            }

            return Center(
              child: SizedBox(
                height: 350 * value,
                width: 350 * value,
                child: _ModelView(index: index),
              ),
            );
          },
        );
      },
    );
  }
}

class _ModelView extends StatelessWidget {
  final int index;

  const _ModelView({required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GlassesController>();
    final model = controller.glassesList[index];
    final isCurrent = index == controller.currentIndex;
    final isTryOnMode = context.select((GlassesController c) => c.isTryOnMode);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Show a loading indicator while the model is fetching
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
        ),
        ModelViewer(
          key: ValueKey('model_${model.name}_$index'),
          backgroundColor: Colors.transparent,
          src: model.modelUrl!,
          alt: model.name,
          autoRotate: !isTryOnMode && isCurrent,
          cameraControls: true,
          disableZoom: true,
          loading: Loading.eager,
        ),
      ],
    );
  }
}

class _ModelMetadata extends StatelessWidget {
  const _ModelMetadata();

  @override
  Widget build(BuildContext context) {
    // Only rebuild this widget when the current model changes
    final modelName = context.select((GlassesController c) => c.currentModel.name);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        modelName,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ViewerControls extends StatelessWidget {
  const _ViewerControls();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GlassesController>();
    final isTryOnMode = context.select((GlassesController c) => c.isTryOnMode);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 40.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SleekIconButton(
            onPressed: controller.previousGlasses,
            icon: Icons.chevron_left_rounded,
          ),
          const SizedBox(width: 24),
          SleekMainButton(
            onPressed: controller.toggleTryOn,
            text: isTryOnMode ? 'View 3D' : 'Try On',
          ),
          const SizedBox(width: 24),
          SleekIconButton(
            onPressed: controller.nextGlasses,
            icon: Icons.chevron_right_rounded,
          ),
        ],
      ),
    );
  }
}
