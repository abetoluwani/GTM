import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/glasses_controller.dart';
import 'try_on/panorama_layer.dart';
import 'try_on/lens_tint_overlay.dart';
import 'try_on/glasses_info_chip.dart';
import 'try_on/drag_hint.dart';
import 'try_on/glasses_vignette_painter.dart';

/// Immersive try-on view that simulates looking through the selected glasses
/// at a panoramic environment. Supports gesture-based panning with momentum,
/// ambient drift, animated lens tinting, and a glasses-frame vignette overlay.
class TryOnView extends StatefulWidget {
  const TryOnView({super.key});

  @override
  State<TryOnView> createState() => _TryOnViewState();
}

class _TryOnViewState extends State<TryOnView> with TickerProviderStateMixin {
  // ── Pan state ──────────────────────────────────────────────────────────
  double _offsetX = 0;
  double _offsetY = 0;

  // ── Momentum decay after fling ─────────────────────────────────────────
  late final AnimationController _decayController;
  double _decayVelocityX = 0;
  double _decayVelocityY = 0;
  double _lastDecayValue = 0;

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

    _decayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..addListener(_applyDecay);

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
    _decayController.dispose();
    _entryController.dispose();
    _entryCurve.dispose();
    _breathController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails _) {
    _decayController.stop();
    if (_hintController.value > 0) _hintController.reverse();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _offsetX += d.delta.dx * 1.2;
      _offsetY = (_offsetY + d.delta.dy * 0.6).clamp(-100.0, 100.0);
    });
  }

  void _onPanEnd(DragEndDetails d) {
    _decayVelocityX = d.velocity.pixelsPerSecond.dx;
    _decayVelocityY = d.velocity.pixelsPerSecond.dy;
    _lastDecayValue = 0;
    _decayController.forward(from: 0);
  }

  void _applyDecay() {
    // Decelerate curve maps 0→1 to fast→stopped
    final t = Curves.decelerate.transform(_decayController.value);
    final delta = t - _lastDecayValue;
    _lastDecayValue = t;

    // Remaining velocity fraction (1 at start, 0 at end)
    final factor = 1.0 - t;
    if (factor <= 0.01) return;

    setState(() {
      _offsetX += _decayVelocityX * delta * 0.35;
      _offsetY =
          (_offsetY + _decayVelocityY * delta * 0.15).clamp(-100.0, 100.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GlassesController>();
    final model = controller.currentModel;
    final size = MediaQuery.of(context).size;

    final imgW = size.width * 3.0;
    final maxPanX = (imgW - size.width) / 2;
    final clampedX = _offsetX.clamp(-maxPanX, maxPanX);

    return FadeTransition(
      opacity: _entryCurve,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.15, end: 1.0).animate(_entryCurve),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PanoramaLayer(
                breathController: _breathController,
                offsetX: clampedX,
                offsetY: _offsetY,
                environmentImage: model.environmentImage,
              ),

              LensTintOverlay(lensColor: model.lensColor),

              IgnorePointer(
                child: CustomPaint(
                  size: size,
                  painter: GlassesVignettePainter(
                    frameColor: model.frameColor,
                  ),
                ),
              ),

              GlassesInfoChip(
                name: model.name,
                frameColor: model.frameColor,
              ),
              DragHint(animation: _hintController),
            ],
          ),
        ),
      ),
    );
  }
}
