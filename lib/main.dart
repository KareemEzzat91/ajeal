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
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish_pull_to_refresh/stylish_pull_to_refresh.dart';

// Constants for SharedPreferences keys
class PreferenceKeys {
  static const String adminLogin = "AdminLogin";
  static const String parentLogin = "ParentLogin";
  static const String adminDoctorId = "adminDoctorId";
  static const String adminDoctorName = "adminDoctorName";
  static const String parentDoctorKey = "parentDoctorKey";
  static const String parentCode = "parentCode";
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Gemini
    Gemini.init(apiKey: Env.apiKey);

    runApp(const MyApp());
  } catch (e) {
    print('Initialization error: $e');
    // You might want to show a user-friendly error screen here
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences _prefs;
  bool _isAdminLogin = false;
  bool _isParentLogin = false;
  String _adminDoctorId = '';
  String _adminDoctorName = '';
  String _parentDoctorKey = '';
  String _parentCode = '';
  Child? _child;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _loadPreferences();
      await _loadChildData();
      setState(() => _isLoading = false);
    } catch (e) {
      print('Error initializing app: $e');
      setState(() {
        _isLoading = false;
        _isParentLogin = false;  // Reset login state on error
      });
    }
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdminLogin = _prefs.getBool(PreferenceKeys.adminLogin) ?? false;
      _isParentLogin = _prefs.getBool(PreferenceKeys.parentLogin) ?? false;
      _adminDoctorId = _prefs.getString(PreferenceKeys.adminDoctorId) ?? '';
      _adminDoctorName = _prefs.getString(PreferenceKeys.adminDoctorName) ?? '';
      _parentDoctorKey = _prefs.getString(PreferenceKeys.parentDoctorKey) ?? '';
      _parentCode = _prefs.getString(PreferenceKeys.parentCode) ?? '';
    });
  }

  Future<void> _loadChildData() async {
    if (_parentCode.isNotEmpty && _parentDoctorKey.isNotEmpty) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(_parentDoctorKey)
            .collection("children")
            .doc(_parentCode)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          setState(() {
            _child = Child.fromJson(userDoc.data()!);
          });
        } else {
          setState(() => _isParentLogin = false);
        }
      } catch (e) {
        print('Error loading child data: $e');
        setState(() => _isParentLogin = false);
      }
    }
  }

  Widget _buildHomeScreen() {
    if (_isAdminLogin) {
      return AdminmainScreen(
        doctorId: _adminDoctorId,
        doctorName: _adminDoctorName,
      );
    }

    if (_isParentLogin && _child != null) {
      return ParentHomePage(
        parentCode: _parentCode,
        child: _child!,
        AdminId: _parentDoctorKey,
      );
    }

    return const AdminOrParentsScreen();
  }

  Widget _buildLoadingScreen() {
    return  StylishPullToRefresh(
      style: Style.circularProgress,

      onRefresh:(){  return fun();} ,
      child: const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200), // Add some spacing
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future <void>fun ()async{

}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainCubit()),
        BlocProvider(create: (context) => SignCubit()),
        BlocProvider(create: (context) => AddChildCubit()),
        BlocProvider(
          create: (context) => ThemesCubit()..setInitialTheme(),
        ),
      ],
      child: BlocBuilder<ThemesCubit, ThemState>(
        builder: (context, state) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: state.themeData,
            locale: state.Loc,
            home: _isLoading ? _buildLoadingScreen() : _buildHomeScreen(),
          );
        },
      ),
    );
  }
}