import 'package:flutter/material.dart';
import '../../widgets/ar_background_view.dart';

class ViewerBackground extends StatelessWidget {
  final bool isTryOnMode;

  const ViewerBackground({super.key, required this.isTryOnMode});

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
