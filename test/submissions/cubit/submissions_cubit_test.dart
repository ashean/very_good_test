import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_app/persistence/submission_repository.dart';
import 'package:my_app/submissions/submissions.dart';

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

void main() {
  group('SubmissionsCubit', () {
    late MockSubmissionRepository mockRepository;
    late SubmissionsCubit cubit;

    setUp(() {
      mockRepository = MockSubmissionRepository();
      cubit = SubmissionsCubit(repository: mockRepository);
    });

    test('initial state is SubmissionsInitial', () {
      expect(cubit.state, equals(const SubmissionsInitial()));
    });

    group('loadSubmissions', () {
      blocTest<SubmissionsCubit, SubmissionsState>(
        'emits [SubmissionsLoading, SubmissionsLoaded] when successful',
        build: () => cubit,
        setUp: () {
          when(() => mockRepository.getSubmissions()).thenAnswer(
            (_) async => [
              Submission(
                id: 1,
                text: 'Test submission',
                submittedAt: DateTime(2025, 6, 27),
              ),
            ],
          );
        },
        act: (cubit) => cubit.loadSubmissions(),
        expect: () => [
          const SubmissionsLoading(),
          SubmissionsLoaded([
            Submission(
              id: 1,
              text: 'Test submission',
              submittedAt: DateTime(2025, 6, 27),
            ),
          ]),
        ],
        verify: (_) {
          verify(() => mockRepository.getSubmissions()).called(1);
        },
      );

      blocTest<SubmissionsCubit, SubmissionsState>(
        'emits [SubmissionsLoading, SubmissionsError] when fails',
        build: () => cubit,
        setUp: () {
          when(
            () => mockRepository.getSubmissions(),
          ).thenThrow(Exception('Failed to load'));
        },
        act: (cubit) => cubit.loadSubmissions(),
        expect: () => [
          const SubmissionsLoading(),
          const SubmissionsError('Exception: Failed to load'),
        ],
      );
    });

    group('deleteSubmission', () {
      blocTest<SubmissionsCubit, SubmissionsState>(
        'removes submission from loaded state when successful',
        build: () => cubit,
        seed: () => SubmissionsLoaded([
          Submission(
            id: 1,
            text: 'First submission',
            submittedAt: DateTime(2025, 6, 27),
          ),
          Submission(
            id: 2,
            text: 'Second submission',
            submittedAt: DateTime(2025, 6, 27),
          ),
        ]),
        setUp: () {
          when(
            () => mockRepository.deleteSubmission(any()),
          ).thenAnswer((_) async {});
        },
        act: (cubit) => cubit.deleteSubmission(1),
        expect: () => [
          SubmissionsLoaded([
            Submission(
              id: 2,
              text: 'Second submission',
              submittedAt: DateTime(2025, 6, 27),
            ),
          ]),
        ],
        verify: (_) {
          verify(() => mockRepository.deleteSubmission(1)).called(1);
        },
      );

      blocTest<SubmissionsCubit, SubmissionsState>(
        'emits error when deletion fails',
        build: () => cubit,
        seed: () => SubmissionsLoaded([
          Submission(
            id: 1,
            text: 'Test submission',
            submittedAt: DateTime(2025, 6, 27),
          ),
        ]),
        setUp: () {
          when(
            () => mockRepository.deleteSubmission(any()),
          ).thenThrow(Exception('Failed to delete'));
        },
        act: (cubit) => cubit.deleteSubmission(1),
        expect: () => [
          const SubmissionsError('Exception: Failed to delete'),
        ],
      );

      blocTest<SubmissionsCubit, SubmissionsState>(
        'does nothing when state is not SubmissionsLoaded',
        build: () => cubit,
        setUp: () {
          when(
            () => mockRepository.deleteSubmission(any()),
          ).thenAnswer((_) async {});
        },
        act: (cubit) => cubit.deleteSubmission(1),
        expect: () => <SubmissionsState>[],
        verify: (_) {
          verifyNever(() => mockRepository.deleteSubmission(any()));
        },
      );
    });

    group('clearAllSubmissions', () {
      blocTest<SubmissionsCubit, SubmissionsState>(
        'emits [SubmissionsLoading, SubmissionsLoaded] with empty list '
        'when successful',
        build: () => cubit,
        setUp: () {
          when(
            () => mockRepository.clearAllSubmissions(),
          ).thenAnswer((_) async {});
        },
        act: (cubit) => cubit.clearAllSubmissions(),
        expect: () => [
          const SubmissionsLoading(),
          const SubmissionsLoaded([]),
        ],
        verify: (_) {
          verify(() => mockRepository.clearAllSubmissions()).called(1);
        },
      );

      blocTest<SubmissionsCubit, SubmissionsState>(
        'emits [SubmissionsLoading, SubmissionsError] when fails',
        build: () => cubit,
        setUp: () {
          when(
            () => mockRepository.clearAllSubmissions(),
          ).thenThrow(Exception('Failed to clear'));
        },
        act: (cubit) => cubit.clearAllSubmissions(),
        expect: () => [
          const SubmissionsLoading(),
          const SubmissionsError('Exception: Failed to clear'),
        ],
      );
    });
  });
}
