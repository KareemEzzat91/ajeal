/// Centralized Firestore collection name constants.
/// Always use these instead of hardcoded strings.
class FirestoreCollections {
  FirestoreCollections._();

  static const String users = 'users';
  static const String children = 'Children';
  static const String dailyNotes = 'DailyNotes';

  // Sub-collections (inside a user document)
  static const String userChildren = 'children';
  static const String userOthersChildren = 'OthersChildren';
}
