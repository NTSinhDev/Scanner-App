import 'package:flutter/material.dart';
import 'package:wolcg_qr_code/di/dependency_injection.dart';

class AppConfig {
  static Future initConfig() async {
    setupDependencyInjection();

    WidgetsFlutterBinding.ensureInitialized();
  }
}
