import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/glasses_controller.dart';

class ModelMetadata extends StatelessWidget {
  const ModelMetadata({super.key});

  @override
  Widget build(BuildContext context) {
    final modelName =
        context.select((GlassesController c) => c.currentModel.name);
    final currentIndex =
        context.select((GlassesController c) => c.currentIndex);
    final total =
        context.select((GlassesController c) => c.glassesList.length);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              modelName,
              key: ValueKey(modelName),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${currentIndex + 1} / $total',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.4),
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
