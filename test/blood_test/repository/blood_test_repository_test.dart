import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/blood_test/repository/blood_test_repository.dart';
import 'package:my_app/drift_test/drift_database.dart';

void main() {
  group('BloodTestRepository', () {
    late AppDatabase database;
    late BloodTestRepository repository;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      repository = BloodTestRepository(database);

      // Insert a test user profile
      await database
          .into(database.userProfiles)
          .insert(
            UserProfilesCompanion.insert(
              name: 'Test User',
              age: 30,
              heightCm: 175,
              weightKg: 70,
              createdAt: DateTime.now(),
            ),
          );
    });

    tearDown(() async {
      await database.close();
    });

    test('addBloodTestResult inserts blood test result', () async {
      final result = await repository.addBloodTestResult(
        userProfileId: 1,
        testDate: DateTime(2023, 1, 15),
        totalCholesterol: 200,
        hdlCholesterol: 60,
        ldlCholesterol: 120,
        triglycerides: 100,
        fastingGlucose: 90,
        hba1c: 5.5,
      );

      expect(result, equals(1));
    });

    test('getBloodTestResults returns all results for user', () async {
      await repository.addBloodTestResult(
        userProfileId: 1,
        testDate: DateTime(2023, 1, 15),
        totalCholesterol: 200,
        hdlCholesterol: 60,
        ldlCholesterol: 120,
        triglycerides: 100,
        fastingGlucose: 90,
        hba1c: 5.5,
      );

      await repository.addBloodTestResult(
        userProfileId: 1,
        testDate: DateTime(2023, 2, 15),
        totalCholesterol: 210,
        hdlCholesterol: 65,
        ldlCholesterol: 125,
        triglycerides: 110,
        fastingGlucose: 95,
        hba1c: 5.7,
      );

      final results = await repository.getBloodTestResults(1);
      expect(results.length, equals(2));
      expect(results[0].totalCholesterol, equals(210));
      expect(results[1].totalCholesterol, equals(200));
    });

    test('getBloodTestResult returns specific result by id', () async {
      await repository.addBloodTestResult(
        userProfileId: 1,
        testDate: DateTime(2023, 1, 15),
        totalCholesterol: 200,
        hdlCholesterol: 60,
        ldlCholesterol: 120,
        triglycerides: 100,
        fastingGlucose: 90,
        hba1c: 5.5,
      );

      final result = await repository.getBloodTestResult(1);
      expect(result, isNotNull);
      expect(result!.totalCholesterol, equals(200));
      expect(result.hdlCholesterol, equals(60));
    });

    test('getBloodTestResult returns null for non-existent id', () async {
      final result = await repository.getBloodTestResult(999);
      expect(result, isNull);
    });

    test('deleteBloodTestResult removes result', () async {
      await repository.addBloodTestResult(
        userProfileId: 1,
        testDate: DateTime(2023, 1, 15),
        totalCholesterol: 200,
        hdlCholesterol: 60,
        ldlCholesterol: 120,
        triglycerides: 100,
        fastingGlucose: 90,
        hba1c: 5.5,
      );

      final deleteCount = await repository.deleteBloodTestResult(1);
      expect(deleteCount, equals(1));

      final result = await repository.getBloodTestResult(1);
      expect(result, isNull);
    });

    test('getAllBloodTestResults returns all results across users', () async {
      // Insert second user profile
      await database
          .into(database.userProfiles)
          .insert(
            UserProfilesCompanion.insert(
              name: 'Test User 2',
              age: 25,
              heightCm: 165,
              weightKg: 60,
              createdAt: DateTime.now(),
            ),
          );

      await repository.addBloodTestResult(
        userProfileId: 1,
        testDate: DateTime(2023, 1, 15),
        totalCholesterol: 200,
        hdlCholesterol: 60,
        ldlCholesterol: 120,
        triglycerides: 100,
        fastingGlucose: 90,
        hba1c: 5.5,
      );

      await repository.addBloodTestResult(
        userProfileId: 2,
        testDate: DateTime(2023, 1, 20),
        totalCholesterol: 180,
        hdlCholesterol: 55,
        ldlCholesterol: 110,
        triglycerides: 90,
        fastingGlucose: 85,
        hba1c: 5.2,
      );

      final results = await repository.getAllBloodTestResults();
      expect(results.length, equals(2));
      expect(results[0].userProfileId, equals(2));
      expect(results[1].userProfileId, equals(1));
    });
  });
}
