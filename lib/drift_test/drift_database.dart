import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'drift_database.g.dart';

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get age => integer()();
  RealColumn get heightCm => real()();
  RealColumn get weightKg => real()();
  DateTimeColumn get createdAt => dateTime()();
}

class BloodTestResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userProfileId => integer().references(UserProfiles, #id)();
  DateTimeColumn get testDate => dateTime()();
  RealColumn get totalCholesterol => real().nullable()();
  RealColumn get hdlCholesterol => real().nullable()();
  RealColumn get ldlCholesterol => real().nullable()();
  RealColumn get triglycerides => real().nullable()();
  RealColumn get fastingGlucose => real().nullable()();
  RealColumn get hba1c => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [TodoItems, UserProfiles, BloodTestResults])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(userProfiles);
        }
        if (from < 3) {
          await m.createTable(bloodTestResults);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
