
import 'package:ajeal/screens/setup/buildhome_screen.dart';
import 'package:ajeal/screens/setup/setup.dart';
import 'package:flutter/material.dart';
Future<void> main() async {
  await Setup.instance.initialize();
    runApp(const MyApp());
}


