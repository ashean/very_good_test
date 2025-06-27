import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/persistence/submission_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Submission', () {
    test('fromJson creates Submission from JSON', () {
      const json = {
        'id': 1,
        'text': 'Test submission',
        'submittedAt': '2025-06-27T10:00:00.000Z',
      };

      final submission = Submission.fromJson(json);

      expect(submission.id, equals(1));
      expect(submission.text, equals('Test submission'));
      expect(
        submission.submittedAt,
        equals(DateTime.parse('2025-06-27T10:00:00.000Z')),
      );
    });

    test('toJson converts Submission to JSON', () {
      final submission = Submission(
        id: 1,
        text: 'Test submission',
        submittedAt: DateTime.parse('2025-06-27T10:00:00.000Z'),
      );

      final json = submission.toJson();

      expect(json['id'], equals(1));
      expect(json['text'], equals('Test submission'));
      expect(json['submittedAt'], equals('2025-06-27T10:00:00.000Z'));
    });
  });

  group('SubmissionRepository', () {
    late SubmissionRepository repository;

    setUp(() {
      repository = const SubmissionRepository();
      SharedPreferences.setMockInitialValues({});
    });

    test(
      'getSubmissions returns empty list when no submissions exist',
      () async {
        final submissions = await repository.getSubmissions();

        expect(submissions, isEmpty);
      },
    );

    test('saveSubmission stores submission with correct data', () async {
      await repository.saveSubmission('Test submission');

      final submissions = await repository.getSubmissions();

      expect(submissions, hasLength(1));
      expect(submissions.first.id, equals(1));
      expect(submissions.first.text, equals('Test submission'));
      expect(submissions.first.submittedAt, isA<DateTime>());
    });

    test('saveSubmission assigns incrementing IDs', () async {
      await repository.saveSubmission('First submission');
      await repository.saveSubmission('Second submission');

      final submissions = await repository.getSubmissions();

      expect(submissions, hasLength(2));
      expect(submissions[0].id, equals(1));
      expect(submissions[1].id, equals(2));
    });

    test('deleteSubmission removes submission by ID', () async {
      await repository.saveSubmission('First submission');
      await repository.saveSubmission('Second submission');

      await repository.deleteSubmission(1);

      final submissions = await repository.getSubmissions();

      expect(submissions, hasLength(1));
      expect(submissions.first.id, equals(2));
      expect(submissions.first.text, equals('Second submission'));
    });

    test('deleteSubmission handles non-existent ID gracefully', () async {
      await repository.saveSubmission('Test submission');

      await repository.deleteSubmission(999);

      final submissions = await repository.getSubmissions();

      expect(submissions, hasLength(1));
      expect(submissions.first.text, equals('Test submission'));
    });

    test('clearAllSubmissions removes all submissions', () async {
      await repository.saveSubmission('First submission');
      await repository.saveSubmission('Second submission');

      await repository.clearAllSubmissions();

      final submissions = await repository.getSubmissions();

      expect(submissions, isEmpty);
    });

    test('getSubmissions returns submissions in correct order', () async {
      await repository.saveSubmission('First submission');
      await repository.saveSubmission('Second submission');
      await repository.saveSubmission('Third submission');

      final submissions = await repository.getSubmissions();

      expect(submissions, hasLength(3));
      expect(submissions[0].text, equals('First submission'));
      expect(submissions[1].text, equals('Second submission'));
      expect(submissions[2].text, equals('Third submission'));
    });
  });
}
