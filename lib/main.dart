import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/pages/splash_screen.dart';

void main() {
  runApp(const BrainBitsApp());
}

class BrainBitsApp extends StatefulWidget {
  const BrainBitsApp({super.key});

  static BrainBitsAppState of(BuildContext context) =>
      context.findAncestorStateOfType<BrainBitsAppState>()!;

  @override
  State<BrainBitsApp> createState() => BrainBitsAppState();
}

class BrainBitsAppState extends State<BrainBitsApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainBits',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: const SplashScreen(),
    );
  }
}
