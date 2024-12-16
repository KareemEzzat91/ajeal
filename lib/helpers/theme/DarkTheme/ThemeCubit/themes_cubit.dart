import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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

  ThemesCubit() : super(ThemState(const Locale("ar"), lightTheme)); // Default to English and Light Theme

  /// Toggles between light and dark themes and saves the preference.
  void toggleTheme(bool isDark) {
    final lang= isDark? "en":"ar";
    print(lang);
    final themeData = isDark ? darkTheme : lightTheme;
    final loc =  Locale(lang);

    emit(ThemState(loc, themeData)); // Retain the current language
    _saveThemePreference(isDark);
  }

  /// Saves the selected theme preference to SharedPreferences.
  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", isDark);
  }

  /// Loads the theme preference from SharedPreferences.
  static Future<bool> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isDark") ?? false;
  }

  /// Initializes the theme based on saved preference.
  Future<void> setInitialTheme() async {
    final isDark = await loadThemePreference();
    final themeData = isDark ? darkTheme : lightTheme;
    emit(ThemState(state.Loc, themeData)); // Retain the current language
  }

  /// Loads the saved language preference from SharedPreferences.
  Future<void> loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('lang') ?? "en"; // Default to English
     final loc = Locale (lang);
    emit(ThemState(loc, state.themeData)); // Retain the current theme
  }

  /// Changes the language and saves the preference to SharedPreferences.
  Future<void> changelang(String lang) async {

   lang= lang =="ar"?"en":"ar";
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', lang);
   final loc =  Locale(lang);
    emit(ThemState(loc, state.themeData)); // Retain the current theme
  }
}
