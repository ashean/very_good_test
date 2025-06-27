import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:my_app/persistence/submission_repository.dart';

class FormCubit extends Cubit<String?> {
  FormCubit({SubmissionRepository? repository})
    : _repository = repository ?? const SubmissionRepository(),
      super(null);

  final SubmissionRepository _repository;

  Future<void> submitText(String text) async {
    log('Form submitted with text: $text');
    await _repository.saveSubmission(text);
    emit(text);
  }
}
