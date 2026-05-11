import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/glasses_controller.dart';
import 'screens/glasses_viewer_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GlassesController(),
      child: const GlassesApp(),
    ),
  );
}

class GlassesApp extends StatelessWidget {
  const GlassesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glasses Try-On',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
      ),
      home: const GlassesViewerScreen(),
    );
  }
}
