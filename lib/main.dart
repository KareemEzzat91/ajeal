import 'package:flutter/material.dart';

import 'core/di/service_locator.dart';
import 'screens/setup/buildhome_screen.dart';
import 'screens/setup/setup.dart';

Future<void> main() async {
  await Setup.instance.initialize();
  setupServiceLocator();
  runApp(const MyApp());
}
