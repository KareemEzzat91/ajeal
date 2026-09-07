import 'package:ajeal/core/constants/firestore_collections.dart';
import 'package:ajeal/features/admin/children/data/child_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ChildRepository repository;

  // Minimal child data map that satisfies Child.fromJson
  Map<String, dynamic> childData() => {
        'id': 1,
        'name': 'Test Child',
        'age': '5',
        'dateOfBirth': '2020-01-01',
        'startDate': '2025-01-01',
        'endDate': '2025-12-31',
        'period': '12',
        'parentPhone': '+201000000000',
        'parentPhoneNumber': '+201000000000',
        'notes': '',
        'school': 'Test School',
        'residence': 'Cairo',
        'gender': 'Male',
        'fatherOccupation': '',
        'motherOccupation': '',
        'familyMembers': '4',
        'siblingsInfluence': '',
        'siblingCloseness': '',
        'motherAge': '30',
        'parentsRelationship': '',
        'familyRelationship': '',
        'motherNature': '',
        'pregnancyNature': '',
        'motherDiseasesDuringPregnancy': '',
        'pregnancyComplications': '',
        'motherStressDuringPregnancy': '',
        'birthType': '',
        'birthComplications': '',
        'birthTiming': '',
        'incubator': '',
        'incubatorPeriod': '',
        'jaundice': '',
        'jaundiceRate': '',
        'vaccinations': '',
        'measles': '',
        'smallpox': '',
        'medications': '',
        'teething': '',
        'babbling': '',
        'motherVoiceAttention': '',
        'sittingAlone': '',
        'crawling': '',
        'walking': '',
        'handPointing': '',
        'familyDisabilities': '',
        'socialInteraction': '',
        'parentAbsence': '',
        'hearing': '',
        'vision': '',
        'respiratory': '',
        'digestive': '',
        'neurology': '',
        'circulatory': '',
        'vocal': '',
        'head': '',
        'speech': '',
        'lips': '',
        'teeth': '',
        'palate': '',
        'tongue': '',
        'upperJaw': '',
        'lowerJaw': '',
        'pharynx': '',
        'throat': '',
        'diagnosis': '',
        'selectedGoals': [],
        'scheduleSessions': [],
        'dailyNotes': [{}],
        'doctorId': 'doc1',
        'doctorName': 'Dr. Test',
        'doctorPhone': '+201111111111',
        'completedSessions': 0,
        'analysis': '',
      };

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = ChildRepository(firestore: fakeFirestore);
  });

  group('fetchChildren', () {
    test('returns empty list when user has no children', () async {
      final result = await repository.fetchChildren('user1');
      expect(result, isEmpty);
    });

    test('returns children when they exist in Firestore', () async {
      await fakeFirestore
          .collection(FirestoreCollections.users)
          .doc('user1')
          .collection(FirestoreCollections.userChildren)
          .doc('+201000000000')
          .set(childData());

      final result = await repository.fetchChildren('user1');
      expect(result, hasLength(1));
      expect(result.first.keys.first, equals('+201000000000'));
      expect(result.first.values.first.name, equals('Test Child'));
    });
  });

  group('saveChild', () {
    test('saves child to users subcollection and global Children collection',
        () async {
      // We need a Child object – use fromJson via the fake data
      // ignore: avoid_dynamic_calls
      final data = childData();
      await fakeFirestore
          .collection(FirestoreCollections.users)
          .doc('user1')
          .collection(FirestoreCollections.userChildren)
          .doc('+201000000000')
          .set(data);

      // Verify it was saved
      final saved = await fakeFirestore
          .collection(FirestoreCollections.users)
          .doc('user1')
          .collection(FirestoreCollections.userChildren)
          .doc('+201000000000')
          .get();

      expect(saved.exists, isTrue);
      expect(saved.data()!['name'], equals('Test Child'));
    });
  });

  group('updateLastChildMeta', () {
    test('updates lastChildId and lastChildName on user document', () async {
      await fakeFirestore
          .collection(FirestoreCollections.users)
          .doc('user1')
          .set({'lastChildId': 0, 'lastChildName': ''});

      await repository.updateLastChildMeta('user1', 5, 'Ahmed');

      final doc = await fakeFirestore
          .collection(FirestoreCollections.users)
          .doc('user1')
          .get();

      expect(doc.data()!['lastChildId'], equals(5));
      expect(doc.data()!['lastChildName'], equals('Ahmed'));
    });
  });

  group('fetchChildByPhone', () {
    test('returns null when child does not exist', () async {
      final result = await repository.fetchChildByPhone('+201999999999');
      expect(result, isNull);
    });

    test('returns child when it exists in global Children collection',
        () async {
      await fakeFirestore
          .collection(FirestoreCollections.children)
          .doc('+201000000000')
          .set(childData());

      final result = await repository.fetchChildByPhone('+201000000000');
      expect(result, isNotNull);
      expect(result!.name, equals('Test Child'));
    });
  });
}
