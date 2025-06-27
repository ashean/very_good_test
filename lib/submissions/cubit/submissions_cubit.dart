import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:my_app/persistence/submission_repository.dart';

part 'submissions_state.dart';

class SubmissionsCubit extends Cubit<SubmissionsState> {
  SubmissionsCubit({SubmissionRepository? repository})
    : _repository = repository ?? const SubmissionRepository(),
      super(const SubmissionsInitial());

  final SubmissionRepository _repository;

  Future<void> loadSubmissions() async {
    emit(const SubmissionsLoading());
    try {
      final submissions = await _repository.getSubmissions();
      emit(SubmissionsLoaded(submissions));
    } on Exception catch (error) {
      emit(SubmissionsError(error.toString()));
    }
  }

  Future<void> deleteSubmission(int id) async {
    if (state is SubmissionsLoaded) {
      final currentState = state as SubmissionsLoaded;
      try {
        await _repository.deleteSubmission(id);
        final updatedSubmissions = currentState.submissions
            .where((submission) => submission.id != id)
            .toList();
        emit(SubmissionsLoaded(updatedSubmissions));
      } on Exception catch (error) {
        emit(SubmissionsError(error.toString()));
      }
    }
  }

  Future<void> clearAllSubmissions() async {
    emit(const SubmissionsLoading());
    try {
      await _repository.clearAllSubmissions();
      emit(const SubmissionsLoaded([]));
    } on Exception catch (error) {
      emit(SubmissionsError(error.toString()));
    }
  }
}
