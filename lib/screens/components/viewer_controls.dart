import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/glasses_controller.dart';
import '../../widgets/sleek_buttons.dart';

class ViewerControls extends StatelessWidget {
  const ViewerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GlassesController>();
    final isTryOnMode =
        context.select((GlassesController c) => c.isTryOnMode);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 40.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isTryOnMode) ...[
            SleekIconButton(
              onPressed: controller.previousGlasses,
              icon: Icons.chevron_left_rounded,
            ),
            const SizedBox(width: 24),
          ],
          SleekMainButton(
            onPressed: controller.toggleTryOn,
            text: isTryOnMode ? 'View 3D' : 'Try On',
          ),
          if (!isTryOnMode) ...[
            const SizedBox(width: 24),
            SleekIconButton(
              onPressed: controller.nextGlasses,
              icon: Icons.chevron_right_rounded,
            ),
          ],
        ],
      ),
    );
  }
}
