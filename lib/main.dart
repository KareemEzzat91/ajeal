
import 'package:ajeal/Screens/setup/buildhome_screen.dart';
import 'package:ajeal/Screens/setup/setup.dart';
import 'package:flutter/material.dart';
Future<void> main() async {
  await Setup.instance.initialize();
    runApp(const MyApp());
}


