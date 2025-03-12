import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildModel/ChildModel.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/AdminmainScreen/AdminmainScreen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/ParentHomeScreen.dart';
import 'package:ajeal/Screens/AdminOrparents/AdminOrParintsScreen.dart';
import 'package:ajeal/firebase_options.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:ajeal/helpers/AIhelper/SecretKey/secretkey.dart';
import 'package:ajeal/helpers/theme/DarkTheme/ThemeCubit/themes_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return StylishPullToRefresh(
      style: Style.circularProgress,
      onRefresh: () {
        return fun();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5F7FA), Color(0xFFE4EDF5)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or branded icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.hourglass_bottom,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 32),
                // Loading text with animation
                const DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A6572),
                  ),
                  child: LoadingAnimatedText('Loading'),
                ),
                const SizedBox(height: 16),
                // Subtle progress indicator
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Helpful tip or message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Pull down to refresh or wait while we load your content',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fun() async {}
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemesCubit(),
      child: BlocBuilder<ThemesCubit, ThemState>(
        builder: (context, state) {
          return GetMaterialApp(
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
            home: _isLoading ? _buildLoadingScreen() : _buildHomeScreen(),
          );
        },
      ),
    );
  }
}

// Animated ellipsis for loading text
class LoadingAnimatedText extends StatefulWidget {
  final String text;

  const LoadingAnimatedText(this.text, {super.key});

  @override
  _LoadingAnimatedTextState createState() => _LoadingAnimatedTextState();
}

class _LoadingAnimatedTextState extends State<LoadingAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      if (_controller.value == 1.0) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.text),
        Text('.' * _dotCount),
      ],
    );
  }
}
