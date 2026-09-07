/// Centralized Firestore collection name constants.
/// Always use these instead of hardcoded strings.
class FirestoreCollections {
  FirestoreCollections._();

  static const String users = 'users';
  static const String children = 'Children';
  static const String doctors = 'Doctors';
  static const String dailyNotes = 'DailyNotes';
  static const String chats = 'Chats';
  static const String reports = 'Reports';
  static const String userStatus = 'UserStatus';

  // Sub-collections (inside a user document)
  static const String userChildren = 'children';
  static const String userOthersChildren = 'OthersChildren';
}
