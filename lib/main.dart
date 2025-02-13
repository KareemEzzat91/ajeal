import 'package:ajeal/Admin/Screens/AdminLoginScreen/cubit/sign_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Screens/AdminOrparents/AdminOrParintsScreen.dart';
 import 'package:ajeal/firebase_options.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:ajeal/helpers/AIhelper/SecretKey/secretkey.dart';
import 'package:ajeal/helpers/theme/DarkTheme/ThemeCubit/themes_cubit.dart';
import 'package:ajeal/maincubit/main_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async{

  Gemini.init(apiKey: Env.apiKey);

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
        BlocProvider(create: (context)=>MainCubit()),
        BlocProvider(create: (context) => SignCubit()),
        BlocProvider(create: (context)=>AddChildCubit()),
        BlocProvider(create: (context) => ThemesCubit()..setInitialTheme()), // إضافة BlocProvider للثيم



      ],
      child:  BlocBuilder<ThemesCubit,ThemState>(
        builder: (context, state) {
          return GetMaterialApp(
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: state.themeData,
            locale: const Locale("ar"), // Use the updated lang
            home: const AdminOrParentsScreen(),
          );
        },
      ),
    );
  }
}

