import 'package:my_app/drift_test/drift_database.dart';

class BackupData {
  const BackupData({
    required this.version,
    required this.schemaVersion,
    required this.exportDate,
    required this.todoItems,
    required this.userProfiles,
    required this.bloodTestResults,
  });

  BackupData.fromJson(Map<String, dynamic> json)
    : version = json['version'] as String,
      schemaVersion = json['schemaVersion'] as int,
      exportDate = DateTime.parse(json['exportDate'] as String),
      todoItems =
          ((json['data'] as Map<String, dynamic>)['todoItems'] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(_todoItemFromJson)
              .toList(),
      userProfiles =
          ((json['data'] as Map<String, dynamic>)['userProfiles']
                  as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(_userProfileFromJson)
              .toList(),
      bloodTestResults =
          ((json['data'] as Map<String, dynamic>)['bloodTestResults']
                  as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(_bloodTestResultFromJson)
              .toList();

  final String version;
  final int schemaVersion;
  final DateTime exportDate;
  final List<TodoItem> todoItems;
  final List<UserProfile> userProfiles;
  final List<BloodTestResult> bloodTestResults;

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'schemaVersion': schemaVersion,
      'exportDate': exportDate.toIso8601String(),
      'data': {
        'todoItems': todoItems.map(_todoItemToJson).toList(),
        'userProfiles': userProfiles.map(_userProfileToJson).toList(),
        'bloodTestResults': bloodTestResults
            .map(_bloodTestResultToJson)
            .toList(),
      },
    };
  }

  static Map<String, dynamic> _todoItemToJson(TodoItem item) {
    return {
      'id': item.id,
      'title': item.title,
      'content': item.content,
      'createdAt': item.createdAt?.toIso8601String(),
    };
  }

  static TodoItem _todoItemFromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  static Map<String, dynamic> _userProfileToJson(UserProfile profile) {
    return {
      'id': profile.id,
      'name': profile.name,
      'age': profile.age,
      'heightCm': profile.heightCm,
      'weightKg': profile.weightKg,
      'createdAt': profile.createdAt.toIso8601String(),
    };
  }

  static UserProfile _userProfileFromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
      heightCm: json['heightCm'] as double,
      weightKg: json['weightKg'] as double,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static Map<String, dynamic> _bloodTestResultToJson(BloodTestResult result) {
    return {
      'id': result.id,
      'userProfileId': result.userProfileId,
      'testDate': result.testDate.toIso8601String(),
      'totalCholesterol': result.totalCholesterol,
      'hdlCholesterol': result.hdlCholesterol,
      'ldlCholesterol': result.ldlCholesterol,
      'triglycerides': result.triglycerides,
      'fastingGlucose': result.fastingGlucose,
      'hba1c': result.hba1c,
      'createdAt': result.createdAt.toIso8601String(),
    };
  }

  static BloodTestResult _bloodTestResultFromJson(Map<String, dynamic> json) {
    return BloodTestResult(
      id: json['id'] as int,
      userProfileId: json['userProfileId'] as int,
      testDate: DateTime.parse(json['testDate'] as String),
      totalCholesterol: json['totalCholesterol'] as double?,
      hdlCholesterol: json['hdlCholesterol'] as double?,
      ldlCholesterol: json['ldlCholesterol'] as double?,
      triglycerides: json['triglycerides'] as double?,
      fastingGlucose: json['fastingGlucose'] as double?,
      hba1c: json['hba1c'] as double?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
