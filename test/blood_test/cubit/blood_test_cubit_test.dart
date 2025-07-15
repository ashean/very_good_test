import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_app/blood_test/cubit/blood_test_cubit.dart';
import 'package:my_app/blood_test/cubit/blood_test_state.dart';
import 'package:my_app/blood_test/repository/blood_test_repository.dart';
import 'package:my_app/drift_test/drift_database.dart';

class MockBloodTestRepository extends Mock implements BloodTestRepository {}

class MockBloodTestResult extends Mock implements BloodTestResult {}

void main() {
  group('BloodTestCubit', () {
    late MockBloodTestRepository mockRepository;
    late BloodTestCubit bloodTestCubit;

    setUp(() {
      mockRepository = MockBloodTestRepository();
      bloodTestCubit = BloodTestCubit(mockRepository);
    });

    test('initial state is BloodTestInitial', () {
      expect(bloodTestCubit.state, equals(const BloodTestInitial()));
    });

    group('submitBloodTestResult', () {
      blocTest<BloodTestCubit, BloodTestState>(
        'emits [BloodTestLoading, BloodTestFormSuccess] when submission '
        'succeeds',
        build: () {
          when(
            () => mockRepository.addBloodTestResult(
              userProfileId: any(named: 'userProfileId'),
              testDate: any(named: 'testDate'),
              totalCholesterol: any(named: 'totalCholesterol'),
              hdlCholesterol: any(named: 'hdlCholesterol'),
              ldlCholesterol: any(named: 'ldlCholesterol'),
              triglycerides: any(named: 'triglycerides'),
              fastingGlucose: any(named: 'fastingGlucose'),
              hba1c: any(named: 'hba1c'),
            ),
          ).thenAnswer((_) async => 1);
          return bloodTestCubit;
        },
        act: (cubit) => cubit.submitBloodTestResult(
          userProfileId: 1,
          testDate: DateTime(2023, 1, 15),
          totalCholesterol: 200,
          hdlCholesterol: 60,
          ldlCholesterol: 120,
          triglycerides: 100,
          fastingGlucose: 90,
          hba1c: 5.5,
        ),
        expect: () => [
          const BloodTestLoading(),
          const BloodTestFormSuccess(),
        ],
      );

      blocTest<BloodTestCubit, BloodTestState>(
        'emits [BloodTestLoading, BloodTestFormError] when submission '
        'fails',
        build: () {
          when(
            () => mockRepository.addBloodTestResult(
              userProfileId: any(named: 'userProfileId'),
              testDate: any(named: 'testDate'),
              totalCholesterol: any(named: 'totalCholesterol'),
              hdlCholesterol: any(named: 'hdlCholesterol'),
              ldlCholesterol: any(named: 'ldlCholesterol'),
              triglycerides: any(named: 'triglycerides'),
              fastingGlucose: any(named: 'fastingGlucose'),
              hba1c: any(named: 'hba1c'),
            ),
          ).thenThrow(Exception('Database error'));
          return bloodTestCubit;
        },
        act: (cubit) => cubit.submitBloodTestResult(
          userProfileId: 1,
          testDate: DateTime(2023, 1, 15),
          totalCholesterol: 200,
          hdlCholesterol: 60,
          ldlCholesterol: 120,
          triglycerides: 100,
          fastingGlucose: 90,
          hba1c: 5.5,
        ),
        expect: () => [
          const BloodTestLoading(),
          const BloodTestFormError(
            'Failed to save blood test result: Exception: Database error',
          ),
        ],
      );
    });

    group('loadBloodTestResults', () {
      blocTest<BloodTestCubit, BloodTestState>(
        'emits [BloodTestLoading, BloodTestListLoaded] when loading succeeds',
        build: () {
          final mockResults = [MockBloodTestResult(), MockBloodTestResult()];
          when(
            () => mockRepository.getBloodTestResults(any()),
          ).thenAnswer((_) async => mockResults);
          return bloodTestCubit;
        },
        act: (cubit) => cubit.loadBloodTestResults(1),
        expect: () => [
          const BloodTestLoading(),
          isA<BloodTestListLoaded>(),
        ],
      );

      blocTest<BloodTestCubit, BloodTestState>(
        'emits [BloodTestLoading, BloodTestListError] when loading fails',
        build: () {
          when(
            () => mockRepository.getBloodTestResults(any()),
          ).thenThrow(Exception('Database error'));
          return bloodTestCubit;
        },
        act: (cubit) => cubit.loadBloodTestResults(1),
        expect: () => [
          const BloodTestLoading(),
          const BloodTestListError(
            'Failed to load blood test results: Exception: Database error',
          ),
        ],
      );
    });

    group('deleteBloodTestResult', () {
      blocTest<BloodTestCubit, BloodTestState>(
        'emits [BloodTestLoading, BloodTestDeleteSuccess] when deletion '
        'succeeds',
        build: () {
          when(
            () => mockRepository.deleteBloodTestResult(any()),
          ).thenAnswer((_) async => 1);
          return bloodTestCubit;
        },
        act: (cubit) => cubit.deleteBloodTestResult(1),
        expect: () => [
          const BloodTestLoading(),
          const BloodTestDeleteSuccess(),
        ],
      );

      blocTest<BloodTestCubit, BloodTestState>(
        'emits [BloodTestLoading, BloodTestDeleteError] when deletion fails',
        build: () {
          when(
            () => mockRepository.deleteBloodTestResult(any()),
          ).thenThrow(Exception('Database error'));
          return bloodTestCubit;
        },
        act: (cubit) => cubit.deleteBloodTestResult(1),
        expect: () => [
          const BloodTestLoading(),
          const BloodTestDeleteError(
            'Failed to delete blood test result: Exception: Database error',
          ),
        ],
      );
    });

    test('resetToInitial resets state to BloodTestInitial', () {
      bloodTestCubit.resetToInitial();
      expect(bloodTestCubit.state, equals(const BloodTestInitial()));
    });
  });
}
