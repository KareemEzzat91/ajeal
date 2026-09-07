import 'package:flutter/material.dart';

import 'package:ajeal/core/di/service_locator.dart';
import 'package:ajeal/features/onboarding/presentation/screens/setup/buildhome_screen.dart';
import 'package:ajeal/features/onboarding/presentation/screens/setup/setup.dart';

Future<void> main() async {
  await Setup.instance.initialize();
  setupServiceLocator();
  runApp(const MyApp());
}
