
import 'package:ajeal/Admin/Screens/AdminLoginScreen/cubit/sign_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildModel/ChildModel.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/AdminmainScreen/AdminmainScreen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/ParentHomeScreen.dart';
import 'package:ajeal/Screens/AdminOrparents/AdminOrParintsScreen.dart';
 import 'package:ajeal/firebase_options.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:ajeal/helpers/AIhelper/SecretKey/secretkey.dart';
import 'package:ajeal/helpers/theme/DarkTheme/ThemeCubit/themes_cubit.dart';
import 'package:ajeal/maincubit/main_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{

  Gemini.init(apiKey: Env.apiKey);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   late final  pref ;
  late  bool AdminLogin=false;
  late  bool ParentLogin=false;
  late  String adminDoctorId;
  late  String adminDoctorName;
  late  String parentDoctorKey;
  late  String parentCode;
  late  Child child ;
  @override
  void initState()  {
    super.initState();
    getFromSharedPrefrence();
  }
  void getFromSharedPrefrence()async{

    final pref = await SharedPreferences.getInstance();
    AdminLogin = pref.getBool("AdminLogin") ?? false;
    ParentLogin = pref.getBool("ParentLogin") ?? false;
    adminDoctorId = pref.getString("adminDoctorId") ?? '';
    adminDoctorName = pref.getString("adminDoctorName") ?? '';
    parentDoctorKey = pref.getString("parentDoctorKey") ?? '';
    parentCode = pref.getString("parentCode") ?? '';
    if (parentCode.isNotEmpty && parentDoctorKey.isNotEmpty) {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(parentDoctorKey)
          .collection("children")
          .doc(parentCode)
          .get();

      if (userDoc.exists && userDoc.data()!.isNotEmpty) {
        child = Child.fromJson(userDoc.data()!);
      }
    }
    else {
      ParentLogin=false;
    }
  }
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
            locale: state.Loc, // Use the updated lang
            home: AdminLogin? AdminmainScreen(doctorId :adminDoctorId,doctorName:adminDoctorName )  : ParentLogin? ParentHomePage(
              parentCode: parentCode,
              child: child,
              AdminId: parentDoctorKey,
            ) :AdminOrParentsScreen(),
          );
        },
      ),
    );
  }
}
/*
*
*/

