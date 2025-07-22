import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_app/data_backup/cubit/data_backup_state.dart';
import 'package:my_app/data_backup/service/backup_service.dart';

class DataBackupCubit extends Cubit<DataBackupState> {
  DataBackupCubit(this._backupService) : super(DataBackupInitial());

  final BackupService _backupService;

  Future<void> exportData() async {
    try {
      emit(DataBackupLoading());
      final jsonData = await _backupService.exportToJson();
      emit(DataBackupExportSuccess(jsonData));
    } on Exception catch (e) {
      emit(DataBackupError('Export failed: $e'));
    }
  }

  Future<void> importData(String jsonString) async {
    try {
      emit(DataBackupLoading());

      final isEmpty = await _backupService.isDatabaseEmpty();
      if (!isEmpty) {
        emit(
          const DataBackupError(
            'Database is not empty. Import is only supported into an '
            'empty database.',
          ),
        );
        return;
      }

      await _backupService.importFromJson(jsonString);
      emit(DataBackupImportSuccess());
    } on Exception catch (e) {
      emit(DataBackupError('Import failed: $e'));
    }
  }

  void resetToInitial() {
    emit(DataBackupInitial());
  }
}
