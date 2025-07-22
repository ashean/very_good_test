import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/data_backup/models/backup_data.dart';

void main() {
  group('BackupData', () {
    group('JSON serialization', () {
      test('toJson creates correct JSON structure', () {
        final backupData = BackupData(
          version: '1.0.0',
          schemaVersion: 3,
          exportDate: DateTime(2025),
          todoItems: const [],
          userProfiles: const [],
          bloodTestResults: const [],
        );

        final json = backupData.toJson();

        expect(json['version'], equals('1.0.0'));
        expect(json['schemaVersion'], equals(3));
        expect(json['exportDate'], equals('2025-01-01T00:00:00.000'));
        expect((json['data'] as Map<String, dynamic>)['todoItems'], isEmpty);
        expect((json['data'] as Map<String, dynamic>)['userProfiles'], isEmpty);
        expect(
          (json['data'] as Map<String, dynamic>)['bloodTestResults'],
          isEmpty,
        );
      });

      test('fromJson parses JSON correctly', () {
        const jsonString = '''
        {
          "version": "1.0.0",
          "schemaVersion": 3,
          "exportDate": "2025-01-01T00:00:00.000Z",
          "data": {
            "todoItems": [],
            "userProfiles": [],
            "bloodTestResults": []
          }
        }
        ''';

        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final backupData = BackupData.fromJson(json);

        expect(backupData.version, equals('1.0.0'));
        expect(backupData.schemaVersion, equals(3));
        expect(backupData.exportDate.toUtc(), equals(DateTime.utc(2025)));
        expect(backupData.todoItems, isEmpty);
        expect(backupData.userProfiles, isEmpty);
        expect(backupData.bloodTestResults, isEmpty);
      });

      test('handles nullable fields correctly', () {
        final backupData = BackupData(
          version: '1.0.0',
          schemaVersion: 3,
          exportDate: DateTime(2025),
          todoItems: const [],
          userProfiles: const [],
          bloodTestResults: const [],
        );

        final json = backupData.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final restored = BackupData.fromJson(decoded);

        expect(restored.version, equals(backupData.version));
        expect(restored.schemaVersion, equals(backupData.schemaVersion));
        expect(restored.exportDate, equals(backupData.exportDate));
      });
    });
  });
}
