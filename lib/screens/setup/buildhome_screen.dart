
import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/core/constants/preference_keys.dart';

import 'package:ajeal/screens/setup/loading_screen.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:ajeal/core/theme/dark_theme/theme_cubit/themes_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ajeal/core/routing/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _adminDoctorPhone = '';
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
      setState(() {
        _isLoading = false;
        _isParentLogin = false; // Reset login state on error
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
      _adminDoctorPhone = _prefs.getString(PreferenceKeys.adminDoctorPhone) ?? '';
      _parentDoctorKey = _prefs.getString(PreferenceKeys.parentDoctorKey) ?? '';
      _parentCode = _prefs.getString(PreferenceKeys.parentCode) ?? '';
    });
  }

  Future<void> _loadChildData() async {
    if (_parentCode.isNotEmpty ) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection("Children")
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
        setState(() => _isParentLogin = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemesCubit(),
      child: BlocBuilder<ThemesCubit, ThemeState>(
        builder: (context, state) {
          if (_isLoading) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: LoadingScreen(context: context),
            );
          }

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            locale: state.loc, // Ensure locale updates
            theme: state.themeData,
            supportedLocales: const [
              Locale('en'), // English
              Locale('ar'), // Arabic
            ],
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: AppRouter.getRouter(
              isAdminLogin: _isAdminLogin,
              adminDoctorId: _adminDoctorId,
              adminDoctorName: _adminDoctorName,
              adminDoctorPhone: _adminDoctorPhone,
              isParentLogin: _isParentLogin,
              child: _child,
              parentCode: _parentCode,
              parentDoctorKey: _parentDoctorKey,
            ),
          );
        },
      ),
    );
  }
}

