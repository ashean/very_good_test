import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/form/form.dart';

void main() {
  group('FormCubit', () {
    test('initial state is null', () {
      expect(FormCubit().state, isNull);
    });

    blocTest<FormCubit, String?>(
      'emits submitted text when submitText is called',
      build: FormCubit.new,
      act: (cubit) => cubit.submitText('Hello World'),
      expect: () => [equals('Hello World')],
    );

    blocTest<FormCubit, String?>(
      'emits new text when submitText is called multiple times',
      build: FormCubit.new,
      act: (cubit) => cubit
        ..submitText('First')
        ..submitText('Second'),
      expect: () => [equals('First'), equals('Second')],
    );

    blocTest<FormCubit, String?>(
      'handles empty string submission',
      build: FormCubit.new,
      act: (cubit) => cubit.submitText(''),
      expect: () => [equals('')],
    );
  });
}
