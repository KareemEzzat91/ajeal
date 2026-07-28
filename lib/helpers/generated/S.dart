import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'S_ar.dart';
import 'S_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/S.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @adminOrParents.
  ///
  /// In en, this message translates to:
  /// **'Who Are You'**
  String get adminOrParents;

  /// No description provided for @parents.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get parents;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @childrenPage.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get childrenPage;

  /// No description provided for @reportsPage.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsPage;

  /// No description provided for @objectivesPage.
  ///
  /// In en, this message translates to:
  /// **'Objectives'**
  String get objectivesPage;

  /// No description provided for @communicationPage.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get communicationPage;

  /// No description provided for @profilePage.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profilePage;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @childrenList.
  ///
  /// In en, this message translates to:
  /// **'Children List '**
  String get childrenList;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get changeTheme;

  /// No description provided for @letsSignIn.
  ///
  /// In en, this message translates to:
  /// **'Lets Make You Sign in  '**
  String get letsSignIn;

  /// No description provided for @enter_information_below.
  ///
  /// In en, this message translates to:
  /// **'Enter the information below'**
  String get enter_information_below;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_password;

  /// No description provided for @loginPage.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginPage;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @alreadyMember.
  ///
  /// In en, this message translates to:
  /// **'Already a Member '**
  String get alreadyMember;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_account;

  /// No description provided for @register_now.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get register_now;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome_back;

  /// No description provided for @sign_in_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue'**
  String get sign_in_to_continue;

  /// No description provided for @parent_code.
  ///
  /// In en, this message translates to:
  /// **'Parent Code'**
  String get parent_code;

  /// No description provided for @enter_parent_code.
  ///
  /// In en, this message translates to:
  /// **'Enter your parent code'**
  String get enter_parent_code;

  /// No description provided for @admin_code.
  ///
  /// In en, this message translates to:
  /// **'Admin Code'**
  String get admin_code;

  /// No description provided for @enter_admin_code.
  ///
  /// In en, this message translates to:
  /// **'Enter admin code'**
  String get enter_admin_code;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// No description provided for @need_help.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get need_help;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support;

  /// No description provided for @invalid_parent_code.
  ///
  /// In en, this message translates to:
  /// **'Invalid parent code. Please try again.'**
  String get invalid_parent_code;

  /// No description provided for @invalid_admin_code.
  ///
  /// In en, this message translates to:
  /// **'Invalid admin code. Please try again.'**
  String get invalid_admin_code;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again later.'**
  String get error_occurred;

  /// No description provided for @welcome_back_Parent.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome_back_Parent;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @progress_overview.
  ///
  /// In en, this message translates to:
  /// **'Progress Overview'**
  String get progress_overview;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get in_progress;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @view_child_goals.
  ///
  /// In en, this message translates to:
  /// **'View Child\'s Goals'**
  String get view_child_goals;

  /// No description provided for @track_progress.
  ///
  /// In en, this message translates to:
  /// **'Track progress and achievements'**
  String get track_progress;

  /// No description provided for @schedule_sessions.
  ///
  /// In en, this message translates to:
  /// **'Schedule Sessions'**
  String get schedule_sessions;

  /// No description provided for @manage_sessions.
  ///
  /// In en, this message translates to:
  /// **'Manage upcoming sessions'**
  String get manage_sessions;

  /// No description provided for @chat_teacher.
  ///
  /// In en, this message translates to:
  /// **'Chat with Teacher'**
  String get chat_teacher;

  /// No description provided for @direct_communication.
  ///
  /// In en, this message translates to:
  /// **'Direct communication channel'**
  String get direct_communication;

  /// No description provided for @global_chat.
  ///
  /// In en, this message translates to:
  /// **'Global Chat'**
  String get global_chat;

  /// No description provided for @connect_community.
  ///
  /// In en, this message translates to:
  /// **'Connect with the community'**
  String get connect_community;

  /// No description provided for @daily_notes.
  ///
  /// In en, this message translates to:
  /// **'Daily Notes'**
  String get daily_notes;

  /// No description provided for @write_daily_notes.
  ///
  /// In en, this message translates to:
  /// **'Write Your Daily Notes'**
  String get write_daily_notes;

  /// No description provided for @emergency_contact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergency_contact;

  /// No description provided for @call_emergency.
  ///
  /// In en, this message translates to:
  /// **'Call Emergency Number'**
  String get call_emergency;

  /// No description provided for @message_teacher.
  ///
  /// In en, this message translates to:
  /// **'Message Teacher'**
  String get message_teacher;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_ar.
  ///
  /// In en, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout_ar;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @treatmentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Treatment Period'**
  String get treatmentPeriod;

  /// No description provided for @familyInformation.
  ///
  /// In en, this message translates to:
  /// **'Family Information'**
  String get familyInformation;

  /// No description provided for @developmentalHistoryPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Developmental History - Pregnancy'**
  String get developmentalHistoryPregnancy;

  /// No description provided for @birthInformation.
  ///
  /// In en, this message translates to:
  /// **'Birth Information'**
  String get birthInformation;

  /// No description provided for @postBirthInformation.
  ///
  /// In en, this message translates to:
  /// **'Post-Birth Information'**
  String get postBirthInformation;

  /// No description provided for @healthHistory.
  ///
  /// In en, this message translates to:
  /// **'Health History'**
  String get healthHistory;

  /// No description provided for @firstYearGrowth.
  ///
  /// In en, this message translates to:
  /// **'First-Year Growth'**
  String get firstYearGrowth;

  /// No description provided for @psychologicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Psychological History'**
  String get psychologicalHistory;

  /// No description provided for @socialHistory.
  ///
  /// In en, this message translates to:
  /// **'Social History'**
  String get socialHistory;

  /// No description provided for @medicalExaminations.
  ///
  /// In en, this message translates to:
  /// **'Medical Examinations'**
  String get medicalExaminations;

  /// No description provided for @oralExamination.
  ///
  /// In en, this message translates to:
  /// **'Oral Examination'**
  String get oralExamination;

  /// No description provided for @diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosis;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// No description provided for @childName.
  ///
  /// In en, this message translates to:
  /// **'Child\'s Name'**
  String get childName;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @parentsContact.
  ///
  /// In en, this message translates to:
  /// **'Parents\' Contact Number'**
  String get parentsContact;

  /// No description provided for @fathersOccupation.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Occupation'**
  String get fathersOccupation;

  /// No description provided for @mothersOccupation.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Occupation'**
  String get mothersOccupation;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// No description provided for @siblingsInfluence.
  ///
  /// In en, this message translates to:
  /// **'Siblings\' Influence'**
  String get siblingsInfluence;

  /// No description provided for @siblingCloseness.
  ///
  /// In en, this message translates to:
  /// **'Sibling Closeness'**
  String get siblingCloseness;

  /// No description provided for @mothersAge.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Age'**
  String get mothersAge;

  /// No description provided for @parentsRelationship.
  ///
  /// In en, this message translates to:
  /// **'Parents\' Relationship'**
  String get parentsRelationship;

  /// No description provided for @familyRelationship.
  ///
  /// In en, this message translates to:
  /// **'Family Relationship'**
  String get familyRelationship;

  /// No description provided for @mothersNature.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Nature'**
  String get mothersNature;

  /// No description provided for @pregnancyNature.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Nature'**
  String get pregnancyNature;

  /// No description provided for @mothersDiseasesDuringPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Diseases During Pregnancy'**
  String get mothersDiseasesDuringPregnancy;

  /// No description provided for @pregnancyComplications.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Complications'**
  String get pregnancyComplications;

  /// No description provided for @mothersStressDuringPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Stress During Pregnancy'**
  String get mothersStressDuringPregnancy;

  /// No description provided for @birthType.
  ///
  /// In en, this message translates to:
  /// **'Type of Birth'**
  String get birthType;

  /// No description provided for @birthComplications.
  ///
  /// In en, this message translates to:
  /// **'Birth Complications'**
  String get birthComplications;

  /// No description provided for @birthTiming.
  ///
  /// In en, this message translates to:
  /// **'Birth Timing'**
  String get birthTiming;

  /// No description provided for @incubator.
  ///
  /// In en, this message translates to:
  /// **'Incubator'**
  String get incubator;

  /// No description provided for @incubatorPeriod.
  ///
  /// In en, this message translates to:
  /// **'Incubator Period'**
  String get incubatorPeriod;

  /// No description provided for @jaundice.
  ///
  /// In en, this message translates to:
  /// **'Jaundice'**
  String get jaundice;

  /// No description provided for @jaundiceRate.
  ///
  /// In en, this message translates to:
  /// **'Jaundice Rate'**
  String get jaundiceRate;

  /// No description provided for @vaccinations.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get vaccinations;

  /// No description provided for @measles.
  ///
  /// In en, this message translates to:
  /// **'Measles'**
  String get measles;

  /// No description provided for @smallpox.
  ///
  /// In en, this message translates to:
  /// **'Smallpox'**
  String get smallpox;

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// No description provided for @teething.
  ///
  /// In en, this message translates to:
  /// **'Teething'**
  String get teething;

  /// No description provided for @babbling.
  ///
  /// In en, this message translates to:
  /// **'Babbling'**
  String get babbling;

  /// No description provided for @attentionToMothersVoice.
  ///
  /// In en, this message translates to:
  /// **'Attention to Mother\'s Voice'**
  String get attentionToMothersVoice;

  /// No description provided for @sittingAlone.
  ///
  /// In en, this message translates to:
  /// **'Sitting Alone'**
  String get sittingAlone;

  /// No description provided for @crawling.
  ///
  /// In en, this message translates to:
  /// **'Crawling'**
  String get crawling;

  /// No description provided for @walking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get walking;

  /// No description provided for @handPointing.
  ///
  /// In en, this message translates to:
  /// **'Hand Pointing'**
  String get handPointing;

  /// No description provided for @familyDisabilities.
  ///
  /// In en, this message translates to:
  /// **'Family Disabilities'**
  String get familyDisabilities;

  /// No description provided for @socialInteraction.
  ///
  /// In en, this message translates to:
  /// **'Social Interaction'**
  String get socialInteraction;

  /// No description provided for @parentAbsence.
  ///
  /// In en, this message translates to:
  /// **'Parent Absence'**
  String get parentAbsence;

  /// No description provided for @hearing.
  ///
  /// In en, this message translates to:
  /// **'Hearing'**
  String get hearing;

  /// No description provided for @vision.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get vision;

  /// No description provided for @respiratory.
  ///
  /// In en, this message translates to:
  /// **'Respiratory System'**
  String get respiratory;

  /// No description provided for @digestive.
  ///
  /// In en, this message translates to:
  /// **'Digestive System'**
  String get digestive;

  /// No description provided for @neurology.
  ///
  /// In en, this message translates to:
  /// **'Neurology'**
  String get neurology;

  /// No description provided for @circulatory.
  ///
  /// In en, this message translates to:
  /// **'Circulatory System'**
  String get circulatory;

  /// No description provided for @vocal.
  ///
  /// In en, this message translates to:
  /// **'Vocal'**
  String get vocal;

  /// No description provided for @head.
  ///
  /// In en, this message translates to:
  /// **'Head'**
  String get head;

  /// No description provided for @speech.
  ///
  /// In en, this message translates to:
  /// **'Speech'**
  String get speech;

  /// No description provided for @lips.
  ///
  /// In en, this message translates to:
  /// **'Lips'**
  String get lips;

  /// No description provided for @teeth.
  ///
  /// In en, this message translates to:
  /// **'Teeth'**
  String get teeth;

  /// No description provided for @palate.
  ///
  /// In en, this message translates to:
  /// **'Palate'**
  String get palate;

  /// No description provided for @tongue.
  ///
  /// In en, this message translates to:
  /// **'Tongue'**
  String get tongue;

  /// No description provided for @upperJaw.
  ///
  /// In en, this message translates to:
  /// **'Upper Jaw'**
  String get upperJaw;

  /// No description provided for @lowerJaw.
  ///
  /// In en, this message translates to:
  /// **'Lower Jaw'**
  String get lowerJaw;

  /// No description provided for @pharynx.
  ///
  /// In en, this message translates to:
  /// **'Pharynx'**
  String get pharynx;

  /// No description provided for @throat.
  ///
  /// In en, this message translates to:
  /// **'Throat'**
  String get throat;

  /// No description provided for @schoolCollege.
  ///
  /// In en, this message translates to:
  /// **'School/College'**
  String get schoolCollege;

  /// No description provided for @residence.
  ///
  /// In en, this message translates to:
  /// **'Residence'**
  String get residence;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @selectGoals.
  ///
  /// In en, this message translates to:
  /// **'Select Goals'**
  String get selectGoals;

  /// No description provided for @saveChildInformation.
  ///
  /// In en, this message translates to:
  /// **'Save Child Information'**
  String get saveChildInformation;

  /// No description provided for @reportsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Reports & Analytics'**
  String get reportsAnalytics;

  /// No description provided for @exportReports.
  ///
  /// In en, this message translates to:
  /// **'Export Reports'**
  String get exportReports;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @totalChildren.
  ///
  /// In en, this message translates to:
  /// **'Total Children'**
  String get totalChildren;

  /// No description provided for @activeGoals.
  ///
  /// In en, this message translates to:
  /// **'Active Goals'**
  String get activeGoals;

  /// No description provided for @successRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get successRate;

  /// No description provided for @detailedReports.
  ///
  /// In en, this message translates to:
  /// **'Detailed Reports'**
  String get detailedReports;

  /// No description provided for @recentActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Activities'**
  String get recentActivities;

  /// No description provided for @ageDistribution.
  ///
  /// In en, this message translates to:
  /// **'Age Distribution'**
  String get ageDistribution;

  /// No description provided for @goalProgress.
  ///
  /// In en, this message translates to:
  /// **'Goal Progress'**
  String get goalProgress;

  /// No description provided for @sessionAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Session Analysis'**
  String get sessionAnalysis;

  /// No description provided for @successMetrics.
  ///
  /// In en, this message translates to:
  /// **'Success Metrics'**
  String get successMetrics;

  /// No description provided for @newChildRegistered.
  ///
  /// In en, this message translates to:
  /// **'New child registered'**
  String get newChildRegistered;

  /// No description provided for @goalUpdated.
  ///
  /// In en, this message translates to:
  /// **'Goal updated for  '**
  String get goalUpdated;

  /// No description provided for @sessionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Session completed with  '**
  String get sessionCompleted;

  /// No description provided for @monthlyReportGenerated.
  ///
  /// In en, this message translates to:
  /// **'Monthly report generated'**
  String get monthlyReportGenerated;

  /// No description provided for @appointmentScheduled.
  ///
  /// In en, this message translates to:
  /// **'Appointment scheduled'**
  String get appointmentScheduled;

  /// No description provided for @doctorCode.
  ///
  /// In en, this message translates to:
  /// **' Code '**
  String get doctorCode;

  /// No description provided for @childDetails.
  ///
  /// In en, this message translates to:
  /// **'Child Details'**
  String get childDetails;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @school.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get school;

  /// No description provided for @parentPhone.
  ///
  /// In en, this message translates to:
  /// **'Parent Phone'**
  String get parentPhone;

  /// No description provided for @fatherOccupation.
  ///
  /// In en, this message translates to:
  /// **'Father Occupation'**
  String get fatherOccupation;

  /// No description provided for @motherOccupation.
  ///
  /// In en, this message translates to:
  /// **'Mother Occupation'**
  String get motherOccupation;

  /// No description provided for @motherAge.
  ///
  /// In en, this message translates to:
  /// **'Mother Age'**
  String get motherAge;

  /// No description provided for @motherNature.
  ///
  /// In en, this message translates to:
  /// **'Mother Nature'**
  String get motherNature;

  /// No description provided for @pregnancyPhase.
  ///
  /// In en, this message translates to:
  /// **'Developmental History - Pregnancy Phase'**
  String get pregnancyPhase;

  /// No description provided for @motherDiseasesDuringPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Mother Diseases During Pregnancy'**
  String get motherDiseasesDuringPregnancy;

  /// No description provided for @motherStressDuringPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Mother Stress During Pregnancy'**
  String get motherStressDuringPregnancy;

  /// No description provided for @birthPhase.
  ///
  /// In en, this message translates to:
  /// **'Birth Phase'**
  String get birthPhase;

  /// No description provided for @postBirth.
  ///
  /// In en, this message translates to:
  /// **'Post-Birth'**
  String get postBirth;

  /// No description provided for @diagnosisDetails.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis Details'**
  String get diagnosisDetails;

  /// No description provided for @doctorInformation.
  ///
  /// In en, this message translates to:
  /// **'Doctor Information'**
  String get doctorInformation;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor Name'**
  String get doctorName;

  /// No description provided for @doctorPhone.
  ///
  /// In en, this message translates to:
  /// **'Doctor Phone'**
  String get doctorPhone;

  /// No description provided for @printReport.
  ///
  /// In en, this message translates to:
  /// **'Print Report'**
  String get printReport;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select your role to continue'**
  String get selectRole;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'hello'**
  String get hello;

  /// No description provided for @loginAsParent.
  ///
  /// In en, this message translates to:
  /// **'Login as a parent to monitor your child\'s progress'**
  String get loginAsParent;

  /// No description provided for @loginAsAdmin.
  ///
  /// In en, this message translates to:
  /// **'Login as admin to manage the system'**
  String get loginAsAdmin;

  /// No description provided for @addNewChild.
  ///
  /// In en, this message translates to:
  /// **'Add New Child'**
  String get addNewChild;

  /// No description provided for @addNewChildOthers.
  ///
  /// In en, this message translates to:
  /// **'Add By Code'**
  String get addNewChildOthers;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @press.
  ///
  /// In en, this message translates to:
  /// **'press here'**
  String get press;

  /// No description provided for @childRate.
  ///
  /// In en, this message translates to:
  /// **'Child Rate '**
  String get childRate;

  /// No description provided for @sessionNote.
  ///
  /// In en, this message translates to:
  /// **'Session Notes'**
  String get sessionNote;

  /// No description provided for @chooseTask.
  ///
  /// In en, this message translates to:
  /// **'Choose Task'**
  String get chooseTask;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
