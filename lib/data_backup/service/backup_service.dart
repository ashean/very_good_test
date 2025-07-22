import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:my_app/data_backup/models/backup_data.dart';
import 'package:my_app/drift_test/drift_database.dart';

class BackupService {
  BackupService(this._database);

  final AppDatabase _database;

  static const String currentVersion = '1.0.0';

  Future<String> exportToJson() async {
    final todoItems = await _database.select(_database.todoItems).get();
    final userProfiles = await _database.select(_database.userProfiles).get();
    final bloodTestResults = await _database
        .select(_database.bloodTestResults)
        .get();

    final backupData = BackupData(
      version: currentVersion,
      schemaVersion: _database.schemaVersion,
      exportDate: DateTime.now(),
      todoItems: todoItems,
      userProfiles: userProfiles,
      bloodTestResults: bloodTestResults,
    );

    final jsonData = backupData.toJson();
    return const JsonEncoder.withIndent('  ').convert(jsonData);
  }

  Future<void> importFromJson(String jsonString) async {
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final backupData = BackupData.fromJson(jsonData);

    if (backupData.schemaVersion != _database.schemaVersion) {
      throw Exception(
        'Schema version mismatch. Export: ${backupData.schemaVersion}, '
        'Current: ${_database.schemaVersion}',
      );
    }

    await _database.transaction(() async {
      await _clearAllData();
      await _importData(backupData);
    });
  }

  Future<void> _clearAllData() async {
    await _database.delete(_database.bloodTestResults).go();
    await _database.delete(_database.userProfiles).go();
    await _database.delete(_database.todoItems).go();
  }

  Future<void> _importData(BackupData backupData) async {
    for (final todoItem in backupData.todoItems) {
      await _database
          .into(_database.todoItems)
          .insert(
            TodoItemsCompanion(
              id: Value(todoItem.id),
              title: Value(todoItem.title),
              content: Value(todoItem.content),
              createdAt: Value(todoItem.createdAt),
            ),
          );
    }

    for (final userProfile in backupData.userProfiles) {
      await _database
          .into(_database.userProfiles)
          .insert(
            UserProfilesCompanion(
              id: Value(userProfile.id),
              name: Value(userProfile.name),
              age: Value(userProfile.age),
              heightCm: Value(userProfile.heightCm),
              weightKg: Value(userProfile.weightKg),
              createdAt: Value(userProfile.createdAt),
            ),
          );
    }

    for (final bloodTestResult in backupData.bloodTestResults) {
      await _database
          .into(_database.bloodTestResults)
          .insert(
            BloodTestResultsCompanion(
              id: Value(bloodTestResult.id),
              userProfileId: Value(bloodTestResult.userProfileId),
              testDate: Value(bloodTestResult.testDate),
              totalCholesterol: Value(bloodTestResult.totalCholesterol),
              hdlCholesterol: Value(bloodTestResult.hdlCholesterol),
              ldlCholesterol: Value(bloodTestResult.ldlCholesterol),
              triglycerides: Value(bloodTestResult.triglycerides),
              fastingGlucose: Value(bloodTestResult.fastingGlucose),
              hba1c: Value(bloodTestResult.hba1c),
              createdAt: Value(bloodTestResult.createdAt),
            ),
          );
    }
  }

  Future<bool> isDatabaseEmpty() async {
    final todoItems = await _database.select(_database.todoItems).get();
    final userProfiles = await _database.select(_database.userProfiles).get();
    final bloodTestResults = await _database
        .select(_database.bloodTestResults)
        .get();

    return todoItems.isEmpty &&
        userProfiles.isEmpty &&
        bloodTestResults.isEmpty;
  }
}
