import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'themes_state.dart';

class ThemesCubit extends Cubit<ThemState> {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[100],
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    iconTheme: const IconThemeData(color: Colors.black54),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white60),
    ),
    iconTheme: const IconThemeData(color: Colors.white60),
  );

  ThemesCubit() : super(ThemState(const Locale("ar"), lightTheme)) {
    _loadPreferences();
  }

  /// Load stored preferences on startup
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool("isDark") ?? false;
    final lang = prefs.getString("lang") ?? "ar"; // Default to Arabic

    emit(ThemState(Locale(lang), isDark ? darkTheme : lightTheme));
  }

  /// Toggle between light and dark themes
  void toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", isDark);

    emit(ThemState(state.loc, isDark ? darkTheme : lightTheme));
  }

  Future<void> changeLang() async {
    final newLocale = state.loc == const Locale("ar") ? const Locale("en") : const Locale("ar");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lang", newLocale.languageCode);

    emit(ThemState(newLocale, state.themeData)); // Ensure UI rebuilds
    Get.updateLocale(newLocale); // Force update

  }

}
