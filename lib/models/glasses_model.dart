import 'package:flutter/material.dart';

class GlassesModel {
  final String name;
  final Color frameColor;
  final Color lensColor;
  final String? modelUrl;

  GlassesModel({
    required this.name,
    required this.frameColor,
    required this.lensColor,
    this.modelUrl,
  });
}
