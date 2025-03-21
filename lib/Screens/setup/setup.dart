import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:ajeal/firebase_options.dart';
import 'package:ajeal/helpers/AIhelper/SecretKey/secretkey.dart';

class Setup {
  Setup._privateConstructor();

  static final Setup _instance = Setup._privateConstructor();

   static Setup get instance => _instance;
   Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Gemini
    Gemini.init(apiKey: Env.apiKey);
  }
}
