// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Who Are You`
  String get AdminOrParents {
    return Intl.message(
      'Who Are You',
      name: 'AdminOrParents',
      desc: '',
      args: [],
    );
  }

  /// `Parents`
  String get Parents {
    return Intl.message(
      'Parents',
      name: 'Parents',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get Admin {
    return Intl.message(
      'Admin',
      name: 'Admin',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message(
      'Login',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get Register {
    return Intl.message(
      'Register',
      name: 'Register',
      desc: '',
      args: [],
    );
  }

  /// `Children`
  String get ChildrenPage {
    return Intl.message(
      'Children',
      name: 'ChildrenPage',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get ReportsPage {
    return Intl.message(
      'Reports',
      name: 'ReportsPage',
      desc: '',
      args: [],
    );
  }

  /// `Objectives`
  String get ObjectivesPage {
    return Intl.message(
      'Objectives',
      name: 'ObjectivesPage',
      desc: '',
      args: [],
    );
  }

  /// `Communication`
  String get CommunicationPage {
    return Intl.message(
      'Communication',
      name: 'CommunicationPage',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get ProfilePage {
    return Intl.message(
      'Profile',
      name: 'ProfilePage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
