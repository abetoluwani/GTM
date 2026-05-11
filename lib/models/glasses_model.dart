import 'package:flutter/material.dart';

class GlassesModel {
  final String name;
  final Color frameColor;
  final Color lensColor;
  final String? modelUrl;
  final String? environmentUrl;
  final String? materialJs;
  final String environmentImage;

  GlassesModel({
    required this.name,
    required this.frameColor,
    required this.lensColor,
    required this.environmentImage,
    this.modelUrl,
    this.environmentUrl,
    this.materialJs,
  });
}
