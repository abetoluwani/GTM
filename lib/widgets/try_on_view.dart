import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/glasses_controller.dart';
import 'try_on/panorama_layer.dart';
import 'try_on/lens_tint_overlay.dart';
import 'try_on/glasses_info_chip.dart';
import 'try_on/drag_hint.dart';
import 'try_on/glasses_vignette_painter.dart';

/// Immersive try-on view that uses a true 360° panorama viewer.
/// Users can look around (up, down, left, right) using gestures or phone sensors.
class TryOnView extends StatefulWidget {
  const TryOnView({super.key});

  @override
  State<TryOnView> createState() => _TryOnViewState();
}

class _TryOnViewState extends State<TryOnView> with TickerProviderStateMixin {
  // ── Entry fade + scale ─────────────────────────────────────────────────
  late final AnimationController _entryController;
  late final CurvedAnimation _entryCurve;

  // ── Ambient breathing drift ────────────────────────────────────────────
  late final AnimationController _breathController;

  // ── Hint fade-out ──────────────────────────────────────────────────────
  late final AnimationController _hintController;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _entryCurve = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: 1.0,
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _hintController.reverse();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _entryCurve.dispose();
    _breathController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GlassesController>();
    final model = controller.currentModel;
    final size = MediaQuery.of(context).size;

    return FadeTransition(
      opacity: _entryCurve,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.1, end: 1.0).animate(_entryCurve),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PanoramaLayer(
              breathController: _breathController,
              environmentImage: model.environmentImage,
            ),

            LensTintOverlay(lensColor: model.lensColor),

            IgnorePointer(
              child: CustomPaint(
                size: size,
                painter: GlassesVignettePainter(frameColor: model.frameColor),
              ),
            ),

            GlassesInfoChip(name: model.name, frameColor: model.frameColor),
            DragHint(animation: _hintController),
          ],
        ),
      ),
    );
  }
}
