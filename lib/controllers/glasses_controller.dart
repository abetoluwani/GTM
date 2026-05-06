import 'package:flutter/material.dart';
import '../models/glasses_model.dart';

class GlassesController extends ChangeNotifier {
  final List<GlassesModel> _glassesList = [
    GlassesModel(
      name: 'Comic',
      frameColor: const Color(0xFFE67E22),
      lensColor: const Color(0xFF8B4513),
      modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
    ),
    GlassesModel(
      name: 'Impressionist',
      frameColor: const Color(0xFF4A90E2),
      lensColor: const Color(0xFF2C5F8D),
      modelUrl:
          'https://cdn.jsdelivr.net/gh/KhronosGroup/glTF-Sample-Assets@main/Models/SunglassesKhronos/SunglassesKhronos.glb',
    ),
    GlassesModel(
      name: 'Sunset',
      frameColor: const Color(0xFF8B9BA8),
      lensColor: const Color(0xFF2C3E50),
      modelUrl:
          'https://cdn.jsdelivr.net/gh/KhronosGroup/glTF-Sample-Assets@main/Models/SunglassesKhronos/SunglassesKhronos.glb',
    ),
    GlassesModel(
      name: 'Ocean',
      frameColor: const Color(0xFF2D8659),
      lensColor: const Color(0xFF1A4D2E),
      modelUrl:
          'https://cdn.jsdelivr.net/gh/KhronosGroup/glTF-Sample-Assets@main/Models/SunglassesKhronos/SunglassesKhronos.glb',
    ),
  ];

  int _currentIndex = 0;
  bool _isTryOnMode = false;
  late final PageController _pageController;

  GlassesController() {
    _pageController = PageController(
      viewportFraction: 0.7,
      initialPage: _currentIndex,
    );
  }

  List<GlassesModel> get glassesList => List.unmodifiable(_glassesList);
  int get currentIndex => _currentIndex;
  bool get isTryOnMode => _isTryOnMode;
  PageController get pageController => _pageController;
  GlassesModel get currentModel => _glassesList[_currentIndex];

  void updateIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }

  void nextGlasses() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void previousGlasses() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void toggleTryOn() {
    _isTryOnMode = !_isTryOnMode;
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
