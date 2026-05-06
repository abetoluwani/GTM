import 'package:flutter/material.dart';

class GlassesModel {
  final String name;
  final Color frameColor;
  final Color lensColor;
  final String? modelUrl;

  /// JavaScript to inject into model-viewer after the model loads.
  /// Used to modify PBR material colors per variant.
  final String? materialJs;

  GlassesModel({
    required this.name,
    required this.frameColor,
    required this.lensColor,
    this.modelUrl,
    this.materialJs,
  });
}
