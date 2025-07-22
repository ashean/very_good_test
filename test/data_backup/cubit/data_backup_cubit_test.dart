import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_app/data_backup/cubit/data_backup_cubit.dart';
import 'package:my_app/data_backup/cubit/data_backup_state.dart';
import 'package:my_app/data_backup/service/backup_service.dart';

class MockBackupService extends Mock implements BackupService {}

void main() {
  late MockBackupService mockBackupService;
  late DataBackupCubit cubit;

  setUp(() {
    mockBackupService = MockBackupService();
    cubit = DataBackupCubit(mockBackupService);
  });

  group('DataBackupCubit', () {
    test('initial state is DataBackupInitial', () {
      expect(cubit.state, equals(DataBackupInitial()));
    });

    blocTest<DataBackupCubit, DataBackupState>(
      'emits [DataBackupLoading, DataBackupExportSuccess] on successful export',
      build: () => cubit,
      setUp: () {
        when(
          () => mockBackupService.exportToJson(),
        ).thenAnswer((_) async => '{"version": "1.0.0"}');
      },
      act: (cubit) => cubit.exportData(),
      expect: () => [
        DataBackupLoading(),
        const DataBackupExportSuccess('{"version": "1.0.0"}'),
      ],
    );

    blocTest<DataBackupCubit, DataBackupState>(
      'emits [DataBackupLoading, DataBackupError] on export failure',
      build: () => cubit,
      setUp: () {
        when(
          () => mockBackupService.exportToJson(),
        ).thenThrow(Exception('Export failed'));
      },
      act: (cubit) => cubit.exportData(),
      expect: () => [
        DataBackupLoading(),
        const DataBackupError('Export failed: Exception: Export failed'),
      ],
    );

    blocTest<DataBackupCubit, DataBackupState>(
      'emits [DataBackupLoading, DataBackupImportSuccess] on successful import',
      build: () => cubit,
      setUp: () {
        when(
          () => mockBackupService.isDatabaseEmpty(),
        ).thenAnswer((_) async => true);
        when(
          () => mockBackupService.importFromJson(any()),
        ).thenAnswer((_) async {});
      },
      act: (cubit) => cubit.importData('{"version": "1.0.0"}'),
      expect: () => [
        DataBackupLoading(),
        DataBackupImportSuccess(),
      ],
    );

    blocTest<DataBackupCubit, DataBackupState>(
      'emits [DataBackupLoading, DataBackupError] when database is not empty',
      build: () => cubit,
      setUp: () {
        when(
          () => mockBackupService.isDatabaseEmpty(),
        ).thenAnswer((_) async => false);
      },
      act: (cubit) => cubit.importData('{"version": "1.0.0"}'),
      expect: () => [
        DataBackupLoading(),
        const DataBackupError(
          'Database is not empty. Import is only supported into an '
          'empty database.',
        ),
      ],
    );

    blocTest<DataBackupCubit, DataBackupState>(
      'emits [DataBackupLoading, DataBackupError] on import failure',
      build: () => cubit,
      setUp: () {
        when(
          () => mockBackupService.isDatabaseEmpty(),
        ).thenAnswer((_) async => true);
        when(
          () => mockBackupService.importFromJson(any()),
        ).thenThrow(Exception('Import failed'));
      },
      act: (cubit) => cubit.importData('{"version": "1.0.0"}'),
      expect: () => [
        DataBackupLoading(),
        const DataBackupError('Import failed: Exception: Import failed'),
      ],
    );

    blocTest<DataBackupCubit, DataBackupState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => const DataBackupError('Some error'),
      act: (cubit) => cubit.resetToInitial(),
      expect: () => [DataBackupInitial()],
    );
  });
}
