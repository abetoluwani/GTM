import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/glasses_model.dart';
import '../widgets/glasses_painter_3d.dart';
import '../widgets/ar_background_view.dart';
import '../widgets/sleek_buttons.dart';

class GlassesViewerScreen extends StatefulWidget {
  const GlassesViewerScreen({super.key});

  @override
  State<GlassesViewerScreen> createState() => _GlassesViewerScreenState();
}

class _GlassesViewerScreenState extends State<GlassesViewerScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isTryOnMode = false;
  late AnimationController _rotationController;
  late AnimationController _transitionController;

  final List<GlassesModel> _glassesList = [
    GlassesModel(
      name: 'Base',
      frameColor: const Color(0xFF8B9BA8),
      lensColor: const Color(0xFF2C3E50),
    ),
    GlassesModel(
      name: 'Forest',
      frameColor: const Color(0xFF2D8659),
      lensColor: const Color(0xFF1A4D2E),
    ),
    GlassesModel(
      name: 'Ocean',
      frameColor: const Color(0xFF4A90E2),
      lensColor: const Color(0xFF2C5F8D),
    ),
    GlassesModel(
      name: 'Sunset',
      frameColor: const Color(0xFFE67E22),
      lensColor: const Color(0xFF8B4513),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _nextGlasses() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _glassesList.length;
    });
  }

  void _previousGlasses() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _glassesList.length) % _glassesList.length;
    });
  }

  void _toggleTryOn() {
    setState(() {
      _isTryOnMode = !_isTryOnMode;
      if (_isTryOnMode) {
        _transitionController.forward();
      } else {
        _transitionController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: _isTryOnMode
                ? const ARBackgroundView(key: ValueKey('ar'))
                : Container(key: const ValueKey('dark'), color: Colors.black),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Glasses Preview Area
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 3D Glasses Model
                        AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(
                                  _isTryOnMode
                                      ? 0
                                      : _rotationController.value * 2 * math.pi,
                                ),
                              alignment: Alignment.center,
                              child: GlassesPainter3D(
                                model: _glassesList[_currentIndex],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 60),

                        // Model Name
                        Text(
                          _glassesList[_currentIndex].name,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 40.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Previous Button
                      SleekIconButton(
                        onPressed: _previousGlasses,
                        icon: Icons.chevron_left_rounded,
                      ),

                      const SizedBox(width: 24),

                      // Try On Button
                      SleekMainButton(
                        onPressed: _toggleTryOn,
                        text: _isTryOnMode ? 'View 3D' : 'Try On',
                      ),

                      const SizedBox(width: 24),

                      // Next Button
                      SleekIconButton(
                        onPressed: _nextGlasses,
                        icon: Icons.chevron_right_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
