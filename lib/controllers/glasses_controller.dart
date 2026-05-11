import 'package:flutter/material.dart';
import '../models/glasses_model.dart';

const _sunglassesUrl = 'assets/models/sunglasses.glb';

/// JavaScript template to target specific parts of the glasses (Frames vs Lenses)
String _colorScript({
  required Color frame,
  required Color lens,
  double opacity = 0.7,
}) {
  final fr = frame.r;
  final fg = frame.g;
  final fb = frame.b;

  final lr = lens.r;
  final lg = lens.g;
  final lb = lens.b;

  return '''
    (function() {
      const mv = document.querySelector('model-viewer');
      const applyStyle = () => {
        if (!mv.model || !mv.model.materials) return;
        
        console.log('Applying colors to materials...');
        mv.model.materials.forEach((mat) => {
          const pbr = mat.pbrMetallicRoughness;
          const currentBase = pbr.baseColorFactor;
          
          // LENS DETECTION: If the part is already semi-transparent, treat it as a lens
          if (currentBase[3] < 0.9 || mat.name.toLowerCase().includes('lens')) {
            pbr.setBaseColorFactor([$lr, $lg, $lb, $opacity]);
            pbr.setRoughnessFactor(0.1);
            pbr.setMetallicFactor(0.1);
          } 
          // FRAME DETECTION: Everything else is a frame
          else {
            pbr.setBaseColorFactor([$fr, $fg, $fb, 1.0]);
            pbr.setRoughnessFactor(0.3);
            pbr.setMetallicFactor(0.7);
          }
        });
      };
      
      if (mv.model) applyStyle();
      mv.addEventListener('load', applyStyle);
      // Extra check for stability
      setTimeout(applyStyle, 100);
      setTimeout(applyStyle, 500);
    })();
  ''';
}

class GlassesController extends ChangeNotifier {
  final List<GlassesModel> _glassesList = [
    GlassesModel(
      name: 'Impressionist',
      frameColor: const Color(0xFF00E5FF),
      lensColor: const Color(0xFF006064),
      environmentImage: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1920&q=80',
      modelUrl: _sunglassesUrl,
      materialJs: _colorScript(
        frame: const Color(0xFF00E5FF),
        lens: const Color(0xFF006064),
        opacity: 0.8,
      ),
    ),
    GlassesModel(
      name: 'Sunset',
      frameColor: const Color(0xFFFF4081),
      lensColor: const Color(0xFFF8BBD0),
      environmentImage: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1920&q=80',
      modelUrl: _sunglassesUrl,
      materialJs: _colorScript(
        frame: const Color(0xFFFF4081),
        lens: const Color(0xFFF8BBD0),
        opacity: 0.5,
      ),
    ),
    GlassesModel(
      name: 'Ocean',
      frameColor: const Color(0xFF7C4DFF),
      lensColor: const Color(0xFFFFFF00),
      environmentImage: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=1920&q=80',
      modelUrl: _sunglassesUrl,
      materialJs: _colorScript(
        frame: const Color(0xFF7C4DFF),
        lens: const Color(0xFFFFFF00),
        opacity: 0.6,
      ),
    ),
    GlassesModel(
      name: 'Midnight',
      frameColor: const Color(0xFF37474F),
      lensColor: const Color(0xFF000000),
      environmentImage: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=1920&q=80',
      modelUrl: _sunglassesUrl,
      materialJs: _colorScript(
        frame: const Color(0xFF37474F),
        lens: const Color(0xFF000000),
        opacity: 0.95,
      ),
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
