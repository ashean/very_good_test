import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Submission extends Equatable {
  const Submission({
    required this.id,
    required this.text,
    required this.submittedAt,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'] as int,
      text: json['text'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
    );
  }

  final int id;
  final String text;
  final DateTime submittedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [id, text, submittedAt];
}

class SubmissionRepository {
  const SubmissionRepository();

  static const String _submissionsKey = 'submissions';

  Future<List<Submission>> getSubmissions() async {
    final prefs = await SharedPreferences.getInstance();
    final submissionsJson = prefs.getStringList(_submissionsKey) ?? [];

    return submissionsJson
        .map(
          (json) =>
              Submission.fromJson(jsonDecode(json) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> saveSubmission(String text) async {
    final submissions = await getSubmissions();
    final nextId = submissions.isEmpty
        ? 1
        : submissions.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1;

    final newSubmission = Submission(
      id: nextId,
      text: text,
      submittedAt: DateTime.now(),
    );

    submissions.add(newSubmission);

    final prefs = await SharedPreferences.getInstance();
    final submissionsJson = submissions
        .map((s) => jsonEncode(s.toJson()))
        .toList();
    await prefs.setStringList(_submissionsKey, submissionsJson);
  }

  Future<void> deleteSubmission(int id) async {
    final submissions = await getSubmissions();
    submissions.removeWhere((s) => s.id == id);

    final prefs = await SharedPreferences.getInstance();
    final submissionsJson = submissions
        .map((s) => jsonEncode(s.toJson()))
        .toList();
    await prefs.setStringList(_submissionsKey, submissionsJson);
  }

  Future<void> clearAllSubmissions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_submissionsKey);
  }
}
