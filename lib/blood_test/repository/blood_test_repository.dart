import 'package:drift/drift.dart';

import 'package:my_app/drift_test/drift_database.dart';

class BloodTestRepository {
  BloodTestRepository(this._database);

  final AppDatabase _database;

  Future<int> addBloodTestResult({
    required int userProfileId,
    required DateTime testDate,
    double? totalCholesterol,
    double? hdlCholesterol,
    double? ldlCholesterol,
    double? triglycerides,
    double? fastingGlucose,
    double? hba1c,
  }) {
    return _database
        .into(_database.bloodTestResults)
        .insert(
          BloodTestResultsCompanion.insert(
            userProfileId: userProfileId,
            testDate: testDate,
            totalCholesterol: Value(totalCholesterol),
            hdlCholesterol: Value(hdlCholesterol),
            ldlCholesterol: Value(ldlCholesterol),
            triglycerides: Value(triglycerides),
            fastingGlucose: Value(fastingGlucose),
            hba1c: Value(hba1c),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<List<BloodTestResult>> getBloodTestResults(int userProfileId) {
    return (_database.select(_database.bloodTestResults)
          ..where((result) => result.userProfileId.equals(userProfileId))
          ..orderBy([(result) => OrderingTerm.desc(result.testDate)]))
        .get();
  }

  Future<BloodTestResult?> getBloodTestResult(int id) {
    return (_database.select(
      _database.bloodTestResults,
    )..where((result) => result.id.equals(id))).getSingleOrNull();
  }

  Future<int> deleteBloodTestResult(int id) {
    return (_database.delete(
      _database.bloodTestResults,
    )..where((result) => result.id.equals(id))).go();
  }

  Future<List<BloodTestResult>> getAllBloodTestResults() {
    return (_database.select(
      _database.bloodTestResults,
    )..orderBy([(result) => OrderingTerm.desc(result.testDate)])).get();
  }
}
