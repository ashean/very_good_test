import 'dart:developer';

import 'package:bloc/bloc.dart';

class FormCubit extends Cubit<String?> {
  FormCubit() : super(null);

  void submitText(String text) {
    log('Form submitted with text: $text');
    emit(text);
  }
}
