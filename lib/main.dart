import 'package:ajeal/Admin/Screens/AdminLoginScreen/cubit/sign_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Screens/AdminOrparents/AdminOrParintsScreen.dart';
 import 'package:ajeal/firebase_options.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async{

  Gemini.init(apiKey: "AIzaSyAydD4VLkskA7IZDfu6tKo3lgxhfjW-grQ");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignCubit()),
        BlocProvider(create: (context)=>AddChildCubit()),

      ],
      child:  GetMaterialApp(
        locale: const Locale("ar"),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const AdminOrParentsScreen(),
      ),
    );
  }
}

