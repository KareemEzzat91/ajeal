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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Who Are You`
  String get adminOrParents {
    return Intl.message(
      'Who Are You',
      name: 'adminOrParents',
      desc: '',
      args: [],
    );
  }

  /// `Parents`
  String get parents {
    return Intl.message('Parents', name: 'parents', desc: '', args: []);
  }

  /// `Admin`
  String get admin {
    return Intl.message('Admin', name: 'admin', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Children`
  String get childrenPage {
    return Intl.message('Children', name: 'childrenPage', desc: '', args: []);
  }

  /// `Reports`
  String get reportsPage {
    return Intl.message('Reports', name: 'reportsPage', desc: '', args: []);
  }

  /// `Objectives`
  String get objectivesPage {
    return Intl.message(
      'Objectives',
      name: 'objectivesPage',
      desc: '',
      args: [],
    );
  }

  /// `Communication`
  String get communicationPage {
    return Intl.message(
      'Communication',
      name: 'communicationPage',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profilePage {
    return Intl.message('Profile', name: 'profilePage', desc: '', args: []);
  }

  /// `Choose from Gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from Gallery',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Take Photo`
  String get takePhoto {
    return Intl.message('Take Photo', name: 'takePhoto', desc: '', args: []);
  }

  /// `Children List `
  String get childrenList {
    return Intl.message(
      'Children List ',
      name: 'childrenList',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInfo {
    return Intl.message(
      'Personal Information',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone {
    return Intl.message('Phone Number', name: 'phone', desc: '', args: []);
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Change Theme`
  String get changeTheme {
    return Intl.message(
      'Change Theme',
      name: 'changeTheme',
      desc: '',
      args: [],
    );
  }

  /// `Lets Make You Sign in  `
  String get letsSignIn {
    return Intl.message(
      'Lets Make You Sign in  ',
      name: 'letsSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Enter the information below`
  String get enter_information_below {
    return Intl.message(
      'Enter the information below',
      name: 'enter_information_below',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgot_password {
    return Intl.message(
      'Forgot Password',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginPage {
    return Intl.message('Login', name: 'loginPage', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Already a Member `
  String get alreadyMember {
    return Intl.message(
      'Already a Member ',
      name: 'alreadyMember',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dont_have_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Register Now`
  String get register_now {
    return Intl.message(
      'Register Now',
      name: 'register_now',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcome_back {
    return Intl.message(
      'Welcome Back!',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in to continue`
  String get sign_in_to_continue {
    return Intl.message(
      'Please sign in to continue',
      name: 'sign_in_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Parent Code`
  String get parent_code {
    return Intl.message('Parent Code', name: 'parent_code', desc: '', args: []);
  }

  /// `Enter your parent code`
  String get enter_parent_code {
    return Intl.message(
      'Enter your parent code',
      name: 'enter_parent_code',
      desc: '',
      args: [],
    );
  }

  /// `Admin Code`
  String get admin_code {
    return Intl.message('Admin Code', name: 'admin_code', desc: '', args: []);
  }

  /// `Enter admin code`
  String get enter_admin_code {
    return Intl.message(
      'Enter admin code',
      name: 'enter_admin_code',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get sign_in {
    return Intl.message('Sign In', name: 'sign_in', desc: '', args: []);
  }

  /// `Need help?`
  String get need_help {
    return Intl.message('Need help?', name: 'need_help', desc: '', args: []);
  }

  /// `Contact Support`
  String get contact_support {
    return Intl.message(
      'Contact Support',
      name: 'contact_support',
      desc: '',
      args: [],
    );
  }

  /// `Invalid parent code. Please try again.`
  String get invalid_parent_code {
    return Intl.message(
      'Invalid parent code. Please try again.',
      name: 'invalid_parent_code',
      desc: '',
      args: [],
    );
  }

  /// `Invalid admin code. Please try again.`
  String get invalid_admin_code {
    return Intl.message(
      'Invalid admin code. Please try again.',
      name: 'invalid_admin_code',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again later.`
  String get error_occurred {
    return Intl.message(
      'An error occurred. Please try again later.',
      name: 'error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcome_back_Parent {
    return Intl.message(
      'Welcome Back!',
      name: 'welcome_back_Parent',
      desc: '',
      args: [],
    );
  }

  /// `Sessions`
  String get sessions {
    return Intl.message('Sessions', name: 'sessions', desc: '', args: []);
  }

  /// `Goals`
  String get goals {
    return Intl.message('Goals', name: 'goals', desc: '', args: []);
  }

  /// `Progress`
  String get progress {
    return Intl.message('Progress', name: 'progress', desc: '', args: []);
  }

  /// `Progress Overview`
  String get progress_overview {
    return Intl.message(
      'Progress Overview',
      name: 'progress_overview',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `In Progress`
  String get in_progress {
    return Intl.message('In Progress', name: 'in_progress', desc: '', args: []);
  }

  /// `Upcoming`
  String get upcoming {
    return Intl.message('Upcoming', name: 'upcoming', desc: '', args: []);
  }

  /// `View Child's Goals`
  String get view_child_goals {
    return Intl.message(
      'View Child\'s Goals',
      name: 'view_child_goals',
      desc: '',
      args: [],
    );
  }

  /// `Track progress and achievements`
  String get track_progress {
    return Intl.message(
      'Track progress and achievements',
      name: 'track_progress',
      desc: '',
      args: [],
    );
  }

  /// `Schedule Sessions`
  String get schedule_sessions {
    return Intl.message(
      'Schedule Sessions',
      name: 'schedule_sessions',
      desc: '',
      args: [],
    );
  }

  /// `Manage upcoming sessions`
  String get manage_sessions {
    return Intl.message(
      'Manage upcoming sessions',
      name: 'manage_sessions',
      desc: '',
      args: [],
    );
  }

  /// `Chat with Teacher`
  String get chat_teacher {
    return Intl.message(
      'Chat with Teacher',
      name: 'chat_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Direct communication channel`
  String get direct_communication {
    return Intl.message(
      'Direct communication channel',
      name: 'direct_communication',
      desc: '',
      args: [],
    );
  }

  /// `Global Chat`
  String get global_chat {
    return Intl.message('Global Chat', name: 'global_chat', desc: '', args: []);
  }

  /// `Connect with the community`
  String get connect_community {
    return Intl.message(
      'Connect with the community',
      name: 'connect_community',
      desc: '',
      args: [],
    );
  }

  /// `Daily Notes`
  String get daily_notes {
    return Intl.message('Daily Notes', name: 'daily_notes', desc: '', args: []);
  }

  /// `Write Your Daily Notes`
  String get write_daily_notes {
    return Intl.message(
      'Write Your Daily Notes',
      name: 'write_daily_notes',
      desc: '',
      args: [],
    );
  }

  /// `Emergency Contact`
  String get emergency_contact {
    return Intl.message(
      'Emergency Contact',
      name: 'emergency_contact',
      desc: '',
      args: [],
    );
  }

  /// `Call Emergency Number`
  String get call_emergency {
    return Intl.message(
      'Call Emergency Number',
      name: 'call_emergency',
      desc: '',
      args: [],
    );
  }

  /// `Message Teacher`
  String get message_teacher {
    return Intl.message(
      'Message Teacher',
      name: 'message_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `تسجيل الخروج`
  String get logout_ar {
    return Intl.message('تسجيل الخروج', name: 'logout_ar', desc: '', args: []);
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
