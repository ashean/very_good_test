import 'package:equatable/equatable.dart';

import 'package:my_app/drift_test/drift_database.dart';

abstract class BloodTestState extends Equatable {
  const BloodTestState();

  @override
  List<Object?> get props => [];
}

class BloodTestInitial extends BloodTestState {
  const BloodTestInitial();
}

class BloodTestLoading extends BloodTestState {
  const BloodTestLoading();
}

class BloodTestFormSuccess extends BloodTestState {
  const BloodTestFormSuccess();
}

class BloodTestFormError extends BloodTestState {
  const BloodTestFormError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class BloodTestListLoaded extends BloodTestState {
  const BloodTestListLoaded(this.results);

  final List<BloodTestResult> results;

  @override
  List<Object?> get props => [results];
}

class BloodTestListError extends BloodTestState {
  const BloodTestListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class BloodTestDeleteSuccess extends BloodTestState {
  const BloodTestDeleteSuccess();
}

class BloodTestDeleteError extends BloodTestState {
  const BloodTestDeleteError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
