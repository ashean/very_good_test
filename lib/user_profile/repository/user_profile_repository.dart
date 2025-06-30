import 'package:my_app/drift_test/drift_database.dart';

class UserProfileRepository {
  UserProfileRepository(this._database);

  final AppDatabase _database;

  Future<List<UserProfile>> getAllUserProfiles() {
    return _database.select(_database.userProfiles).get();
  }

  Future<UserProfile?> getUserProfile(int id) {
    return (_database.select(
      _database.userProfiles,
    )..where((profile) => profile.id.equals(id))).getSingleOrNull();
  }

  Future<int> addUserProfile({
    required String name,
    required int age,
    required double heightCm,
    required double weightKg,
  }) {
    return _database
        .into(_database.userProfiles)
        .insert(
          UserProfilesCompanion.insert(
            name: name,
            age: age,
            heightCm: heightCm,
            weightKg: weightKg,
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<bool> updateUserProfile(UserProfile profile) {
    return _database.update(_database.userProfiles).replace(profile);
  }

  Future<int> deleteUserProfile(int id) {
    return (_database.delete(
      _database.userProfiles,
    )..where((profile) => profile.id.equals(id))).go();
  }
}
