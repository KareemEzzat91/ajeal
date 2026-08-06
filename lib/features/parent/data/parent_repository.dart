import 'package:ajeal/core/constants/firestore_collections.dart';
import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for parent-side data access.
class ParentRepository {
  ParentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Fetches the child associated with [parentCode] from the global
  /// Children collection.
  Future<Child?> fetchChildByCode(String parentCode) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.children)
          .doc(parentCode)
          .get();
      if (doc.exists && doc.data() != null) {
        return Child.fromJson(doc.data()!);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
