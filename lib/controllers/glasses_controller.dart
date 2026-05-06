import 'package:flutter/material.dart';
import '../models/glasses_model.dart';

const _sunglassesUrl =
    'https://cdn.jsdelivr.net/gh/KhronosGroup/glTF-Sample-Assets@main/Models/SunglassesKhronos/glTF-Binary/SunglassesKhronos.glb';

String _colorScript({
  required double fr,
  required double fg,
  required double fb,
}) {
  return '''
    (function() {
      const mv = document.querySelector('model-viewer');
      const applyColor = () => {
        if (!mv.model) return;
        const mats = mv.model.materials;
        for (const mat of mats) {
          const pbr = mat.pbrMetallicRoughness;
          const cur = pbr.baseColorFactor;
          pbr.setBaseColorFactor([$fr, $fg, $fb, cur[3]]);
          
          // Make it look more premium/matte
          pbr.setRoughnessFactor(0.4);
          pbr.setMetallicFactor(0.2);
        }
      };
      
      // Apply immediately if already loaded, otherwise wait for load
      if (mv.model) {
        applyColor();
      }
      mv.addEventListener('load', applyColor);
    })();
  ''';
}

class GlassesController extends ChangeNotifier {
  final List<GlassesModel> _glassesList = [
    GlassesModel(
      name: 'Impressionist',
      frameColor: const Color(0xFF4A90E2),
      lensColor: const Color(0xFF2C5F8D),
      modelUrl: _sunglassesUrl,
      materialJs: _colorScript(fr: 0.29, fg: 0.56, fb: 0.89),
    ),
    GlassesModel(
      name: 'Sunset',
      frameColor: const Color(0xFFE67E22),
      lensColor: const Color(0xFF8B4513),
      modelUrl: _sunglassesUrl,
      materialJs: _colorScript(fr: 0.90, fg: 0.49, fb: 0.13),
    ),
    GlassesModel(
      name: 'Ocean',
      frameColor: const Color(0xFF2D8659),
      lensColor: const Color(0xFF1A4D2E),
      modelUrl: _sunglassesUrl,
      materialJs: _colorScript(fr: 0.18, fg: 0.53, fb: 0.35),
    ),
    GlassesModel(
      name: 'Midnight',
      frameColor: const Color(0xFF8B9BA8),
      lensColor: const Color(0xFF2C3E50),
      modelUrl: _sunglassesUrl,
      materialJs: _colorScript(fr: 0.55, fg: 0.61, fb: 0.66),
    ),
  ];

  int _currentIndex = 0;
  bool _isTryOnMode = false;
  bool _isTransitioning = false;

  List<GlassesModel> get glassesList => List.unmodifiable(_glassesList);
  int get currentIndex => _currentIndex;
  bool get isTryOnMode => _isTryOnMode;
  bool get isTransitioning => _isTransitioning;
  GlassesModel get currentModel => _glassesList[_currentIndex];

  void updateIndex(int index) {
    if (_currentIndex == index) return;
    if (index < 0 || index >= _glassesList.length) return;
    _isTransitioning = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 200), () {
      _currentIndex = index;
      _isTransitioning = false;
      notifyListeners();
    });
  }

  void nextGlasses() {
    if (_isTransitioning) return;
    final nextIndex = (_currentIndex + 1) % _glassesList.length;
    updateIndex(nextIndex);
  }

  void previousGlasses() {
    if (_isTransitioning) return;
    final prevIndex =
        (_currentIndex - 1 + _glassesList.length) % _glassesList.length;
    updateIndex(prevIndex);
  }

  void toggleTryOn() {
    _isTryOnMode = !_isTryOnMode;
    notifyListeners();
  }
}
