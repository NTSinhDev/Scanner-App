import 'package:flutter/material.dart';
import 'package:wolcg_qr_code/app/app_entry.dart';
import 'package:wolcg_qr_code/app/app_flavor_config.dart';
import 'di/dependency_injection.dart';

void main() {
  FlavorConfig(env: Flavor.staging);
  setupDependencyInjection();
  runApp(const WOLCGAttendanceApp());
}