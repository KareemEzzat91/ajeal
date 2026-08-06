import 'package:ajeal/core/constants/firestore_collections.dart';
import 'package:ajeal/features/admin/children/data/doctor_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late DoctorRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = DoctorRepository(firestore: fakeFirestore);
  });

  group('getDoctorInfo', () {
    test('returns default Doctor when user does not exist', () async {
      final doctor = await repository.getDoctorInfo('nonexistent');
      expect(doctor, isNotNull);
      expect(doctor!.doctorName, equals(''));
      expect(doctor.lastChildId, equals(0));
    });

    test('returns Doctor with Firestore data when user exists', () async {
      await fakeFirestore
          .collection(FirestoreCollections.users)
          .doc('doc1')
          .set({
        'Doctor_Name': 'Dr. Ahmed',
        'Doctor_id': 'doc1',
        'Doctor_phone': '+201234567890',
        'lastChildId': 3,
        'lastChildName': 'Youssef',
        'lastSessionWith': '',
        'taskAddedFor': '',
        'lastChattedWith': '',
      });

      final doctor = await repository.getDoctorInfo('doc1');
      expect(doctor!.doctorName, equals('Dr. Ahmed'));
      expect(doctor.lastChildId, equals(3));
    });
  });

  group('updateDoctorField', () {
    test('updates a single field on the doctor document', () async {
      await fakeFirestore
          .collection(FirestoreCollections.users)
          .doc('doc1')
          .set({'Doctor_Name': 'Old Name', 'lastChildName': ''});

      await repository.updateDoctorField('doc1', 'Doctor_Name', 'New Name');

      final doc = await fakeFirestore
          .collection(FirestoreCollections.users)
          .doc('doc1')
          .get();
      expect(doc.data()!['Doctor_Name'], equals('New Name'));
    });
  });
}
