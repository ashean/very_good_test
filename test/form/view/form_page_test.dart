import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_app/form/form.dart';

import '../../helpers/helpers.dart';

class MockFormCubit extends MockCubit<String?> implements FormCubit {}

void main() {
  group('FormPage', () {
    testWidgets('renders FormView', (tester) async {
      await tester.pumpApp(const FormPage());
      expect(find.byType(FormView), findsOneWidget);
    });
  });

  group('FormView', () {
    late FormCubit formCubit;

    setUp(() {
      formCubit = MockFormCubit();
    });

    testWidgets('renders text field and submit button', (tester) async {
      when(() => formCubit.state).thenReturn(null);
      await tester.pumpApp(
        BlocProvider.value(value: formCubit, child: const FormView()),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('shows submitted text when state is not null', (tester) async {
      const submittedText = 'Hello World';
      when(() => formCubit.state).thenReturn(submittedText);
      await tester.pumpApp(
        BlocProvider.value(value: formCubit, child: const FormView()),
      );

      expect(find.text('Submitted: $submittedText'), findsOneWidget);
    });

    testWidgets('does not show submitted text when state is null', (
      tester,
    ) async {
      when(() => formCubit.state).thenReturn(null);
      await tester.pumpApp(
        BlocProvider.value(value: formCubit, child: const FormView()),
      );

      expect(find.textContaining('Submitted:'), findsNothing);
    });

    testWidgets('calls submitText when submit button is pressed', (
      tester,
    ) async {
      when(() => formCubit.state).thenReturn(null);
      when(() => formCubit.submitText(any())).thenReturn(null);

      await tester.pumpApp(
        BlocProvider.value(value: formCubit, child: const FormView()),
      );

      const testText = 'Test input';
      await tester.enterText(find.byType(TextField), testText);
      await tester.tap(find.byType(ElevatedButton));

      verify(() => formCubit.submitText(testText)).called(1);
    });

    testWidgets('clears text field after submission', (tester) async {
      when(() => formCubit.state).thenReturn(null);
      when(() => formCubit.submitText(any())).thenReturn(null);

      await tester.pumpApp(
        BlocProvider.value(value: formCubit, child: const FormView()),
      );

      const testText = 'Test input';
      await tester.enterText(find.byType(TextField), testText);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('calls submitText when Enter is pressed in text field', (
      tester,
    ) async {
      when(() => formCubit.state).thenReturn(null);
      when(() => formCubit.submitText(any())).thenReturn(null);

      await tester.pumpApp(
        BlocProvider.value(value: formCubit, child: const FormView()),
      );

      const testText = 'Test input';
      await tester.enterText(find.byType(TextField), testText);
      await tester.testTextInput.receiveAction(TextInputAction.done);

      verify(() => formCubit.submitText(testText)).called(1);
    });
  });
}
