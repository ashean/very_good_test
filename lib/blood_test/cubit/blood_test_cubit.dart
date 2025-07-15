import 'package:bloc/bloc.dart';

import 'package:my_app/blood_test/cubit/blood_test_state.dart';
import 'package:my_app/blood_test/repository/blood_test_repository.dart';
import 'package:my_app/core/logging/app_logger.dart';

class BloodTestCubit extends Cubit<BloodTestState> {
  BloodTestCubit(this._repository) : super(const BloodTestInitial());

  final BloodTestRepository _repository;

  Future<void> submitBloodTestResult({
    required int userProfileId,
    required DateTime testDate,
    double? totalCholesterol,
    double? hdlCholesterol,
    double? ldlCholesterol,
    double? triglycerides,
    double? fastingGlucose,
    double? hba1c,
  }) async {
    emit(const BloodTestLoading());
    try {
      await _repository.addBloodTestResult(
        userProfileId: userProfileId,
        testDate: testDate,
        totalCholesterol: totalCholesterol,
        hdlCholesterol: hdlCholesterol,
        ldlCholesterol: ldlCholesterol,
        triglycerides: triglycerides,
        fastingGlucose: fastingGlucose,
        hba1c: hba1c,
      );
      emit(const BloodTestFormSuccess());
    } on Exception catch (e, stackTrace) {
      AppLogger.logError(
        'Failed to save blood test result',
        e,
        stackTrace,
        'BloodTestCubit',
      );
      emit(BloodTestFormError('Failed to save blood test result: $e'));
    }
  }

  Future<void> loadBloodTestResults(int userProfileId) async {
    emit(const BloodTestLoading());
    try {
      final results = await _repository.getBloodTestResults(userProfileId);
      emit(BloodTestListLoaded(results));
    } on Exception catch (e, stackTrace) {
      AppLogger.logError(
        'Failed to load blood test results',
        e,
        stackTrace,
        'BloodTestCubit',
      );
      emit(BloodTestListError('Failed to load blood test results: $e'));
    }
  }

  Future<void> deleteBloodTestResult(int id) async {
    emit(const BloodTestLoading());
    try {
      await _repository.deleteBloodTestResult(id);
      emit(const BloodTestDeleteSuccess());
    } on Exception catch (e, stackTrace) {
      AppLogger.logError(
        'Failed to delete blood test result',
        e,
        stackTrace,
        'BloodTestCubit',
      );
      emit(BloodTestDeleteError('Failed to delete blood test result: $e'));
    }
  }

  void resetToInitial() {
    emit(const BloodTestInitial());
  }
}
