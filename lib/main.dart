import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/storage_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final storageService = StorageService();
  await storageService.init();

  runApp(
    ChangeNotifierProvider.value(
      value: storageService,
      child: const ProfileForgeApp(),
    ),
  );
}
