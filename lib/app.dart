import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

class ProfileForgeApp extends StatelessWidget {
  const ProfileForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();

    return MaterialApp(
      title: 'ProfileForge AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: storage.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
