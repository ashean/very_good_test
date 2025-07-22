import 'package:equatable/equatable.dart';

abstract class DataBackupState extends Equatable {
  const DataBackupState();

  @override
  List<Object> get props => [];
}

class DataBackupInitial extends DataBackupState {}

class DataBackupLoading extends DataBackupState {}

class DataBackupExportSuccess extends DataBackupState {
  const DataBackupExportSuccess(this.jsonData);

  final String jsonData;

  @override
  List<Object> get props => [jsonData];
}

class DataBackupImportSuccess extends DataBackupState {}

class DataBackupError extends DataBackupState {
  const DataBackupError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
