import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_app/blood_test/cubit/blood_test_cubit.dart';
import 'package:my_app/blood_test/cubit/blood_test_state.dart';
import 'package:my_app/blood_test/view/blood_test_form_page.dart';
import 'package:my_app/drift_test/drift_database.dart';

import '../../helpers/helpers.dart';

class MockBloodTestCubit extends MockCubit<BloodTestState>
    implements BloodTestCubit {}

void main() {
  group('BloodTestFormPage', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    testWidgets('renders BloodTestFormView', (tester) async {
      await tester.pumpApp(
        BloodTestFormPage(userProfileId: 1, database: database),
      );
      expect(find.byType(BloodTestFormView), findsOneWidget);
    });
  });

  group('BloodTestFormView', () {
    late BloodTestCubit bloodTestCubit;

    setUp(() {
      bloodTestCubit = MockBloodTestCubit();
    });

    testWidgets('renders form with all input fields', (tester) async {
      when(() => bloodTestCubit.state).thenReturn(const BloodTestInitial());

      await tester.pumpApp(
        BlocProvider.value(
          value: bloodTestCubit,
          child: const BloodTestFormView(userProfileId: 1),
        ),
      );

      expect(find.text('Blood Test Results'), findsOneWidget);
      expect(find.text('Test Date'), findsOneWidget);
      expect(find.text('Total Cholesterol (mg/dL)'), findsOneWidget);
      expect(find.text('HDL Cholesterol (mg/dL)'), findsOneWidget);
      expect(find.text('LDL Cholesterol (mg/dL)'), findsOneWidget);
      expect(find.text('Triglycerides (mg/dL)'), findsOneWidget);
      expect(find.text('Fasting Glucose (mg/dL)'), findsOneWidget);
      expect(find.text('HbA1c (%)'), findsOneWidget);
      expect(find.text('Save Results'), findsOneWidget);
    });

    testWidgets('shows loading indicator when state is loading', (
      tester,
    ) async {
      when(() => bloodTestCubit.state).thenReturn(const BloodTestLoading());

      await tester.pumpApp(
        BlocProvider.value(
          value: bloodTestCubit,
          child: const BloodTestFormView(userProfileId: 1),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows success message when form submission succeeds', (
      tester,
    ) async {
      when(() => bloodTestCubit.state).thenReturn(const BloodTestFormSuccess());

      await tester.pumpApp(
        BlocProvider.value(
          value: bloodTestCubit,
          child: const BloodTestFormView(userProfileId: 1),
        ),
      );

      expect(
        find.text('Blood test results saved successfully!'),
        findsOneWidget,
      );
    });

    testWidgets('shows error message when form submission fails', (
      tester,
    ) async {
      const errorMessage = 'Failed to save blood test result';
      whenListen(
        bloodTestCubit,
        Stream.fromIterable([
          const BloodTestInitial(),
          const BloodTestFormError(errorMessage),
        ]),
        initialState: const BloodTestInitial(),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: bloodTestCubit,
          child: const BloodTestFormView(userProfileId: 1),
        ),
      );

      // Wait for the state change and snackbar to appear
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('calls submitBloodTestResult when form is submitted', (
      tester,
    ) async {
      when(() => bloodTestCubit.state).thenReturn(const BloodTestInitial());
      when(
        () => bloodTestCubit.submitBloodTestResult(
          userProfileId: any(named: 'userProfileId'),
          testDate: any(named: 'testDate'),
          totalCholesterol: any(named: 'totalCholesterol'),
          hdlCholesterol: any(named: 'hdlCholesterol'),
          ldlCholesterol: any(named: 'ldlCholesterol'),
          triglycerides: any(named: 'triglycerides'),
          fastingGlucose: any(named: 'fastingGlucose'),
          hba1c: any(named: 'hba1c'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpApp(
        BlocProvider.value(
          value: bloodTestCubit,
          child: const BloodTestFormView(userProfileId: 1),
        ),
      );

      // First select a test date
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Enter test data
      await tester.enterText(
        find.byKey(const Key('totalCholesterolField')),
        '200',
      );
      await tester.enterText(
        find.byKey(const Key('hdlCholesterolField')),
        '60',
      );
      await tester.enterText(
        find.byKey(const Key('ldlCholesterolField')),
        '120',
      );
      await tester.enterText(
        find.byKey(const Key('triglyceridesField')),
        '100',
      );
      await tester.enterText(
        find.byKey(const Key('fastingGlucoseField')),
        '90',
      );
      await tester.enterText(find.byKey(const Key('hba1cField')), '5.5');

      // Scroll to see the save button
      await tester.ensureVisible(find.byKey(const Key('saveResultsButton')));
      await tester.pumpAndSettle();

      // Tap save button
      await tester.tap(find.byKey(const Key('saveResultsButton')));
      await tester.pump();

      verify(
        () => bloodTestCubit.submitBloodTestResult(
          userProfileId: 1,
          testDate: any(named: 'testDate'),
          totalCholesterol: 200,
          hdlCholesterol: 60,
          ldlCholesterol: 120,
          triglycerides: 100,
          fastingGlucose: 90,
          hba1c: 5.5,
        ),
      ).called(1);
    });

    testWidgets('validates required fields', (tester) async {
      when(() => bloodTestCubit.state).thenReturn(const BloodTestInitial());

      await tester.pumpApp(
        BlocProvider.value(
          value: bloodTestCubit,
          child: const BloodTestFormView(userProfileId: 1),
        ),
      );

      // Scroll to see the save button
      await tester.ensureVisible(find.byKey(const Key('saveResultsButton')));
      await tester.pumpAndSettle();

      // Tap save button without entering any data
      await tester.tap(find.byKey(const Key('saveResultsButton')));
      await tester.pumpAndSettle();

      // Should show validation error for test date
      expect(find.text('Please select a test date'), findsOneWidget);
    });

    testWidgets('resets form after successful submission', (tester) async {
      when(() => bloodTestCubit.state).thenReturn(const BloodTestFormSuccess());

      await tester.pumpApp(
        BlocProvider.value(
          value: bloodTestCubit,
          child: const BloodTestFormView(userProfileId: 1),
        ),
      );

      // Tap "Add Another" button
      await tester.tap(find.text('Add Another'));
      await tester.pump();

      verify(() => bloodTestCubit.resetToInitial()).called(1);
    });
  });
}
