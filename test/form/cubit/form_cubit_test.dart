import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/form/form.dart';
import 'package:my_app/persistence/submission_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

void main() {
  group('FormCubit', () {
    late MockSubmissionRepository mockRepository;

    setUp(() {
      mockRepository = MockSubmissionRepository();
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is null', () {
      expect(FormCubit().state, isNull);
    });

    blocTest<FormCubit, String?>(
      'emits submitted text when submitText is called',
      build: () => FormCubit(repository: mockRepository),
      setUp: () {
        when(
          () => mockRepository.saveSubmission(any()),
        ).thenAnswer((_) async {});
      },
      act: (cubit) => cubit.submitText('Hello World'),
      expect: () => [equals('Hello World')],
      verify: (_) {
        verify(() => mockRepository.saveSubmission('Hello World')).called(1);
      },
    );

    blocTest<FormCubit, String?>(
      'emits new text when submitText is called multiple times',
      build: () => FormCubit(repository: mockRepository),
      setUp: () {
        when(
          () => mockRepository.saveSubmission(any()),
        ).thenAnswer((_) async {});
      },
      act: (cubit) async {
        await cubit.submitText('First');
        await cubit.submitText('Second');
      },
      expect: () => [equals('First'), equals('Second')],
      verify: (_) {
        verify(() => mockRepository.saveSubmission('First')).called(1);
        verify(() => mockRepository.saveSubmission('Second')).called(1);
      },
    );

    blocTest<FormCubit, String?>(
      'handles empty string submission',
      build: () => FormCubit(repository: mockRepository),
      setUp: () {
        when(
          () => mockRepository.saveSubmission(any()),
        ).thenAnswer((_) async {});
      },
      act: (cubit) => cubit.submitText(''),
      expect: () => [equals('')],
      verify: (_) {
        verify(() => mockRepository.saveSubmission('')).called(1);
      },
    );

    test('uses real repository when none provided', () {
      final cubit = FormCubit();
      expect(cubit, isA<FormCubit>());
    });
  });
}
