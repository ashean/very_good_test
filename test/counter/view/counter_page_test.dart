import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_app/counter/counter.dart';

import '../../helpers/helpers.dart';

class MockCounterCubit extends MockCubit<int> implements CounterCubit {}

void main() {
  group('CounterPage', () {
    testWidgets('renders CounterView', (tester) async {
      await tester.pumpApp(const CounterPage());
      expect(find.byType(CounterView), findsOneWidget);
    });
  });

  group('CounterView', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = MockCounterCubit();
    });

    testWidgets('renders current count', (tester) async {
      const state = 42;
      when(() => counterCubit.state).thenReturn(state);
      await tester.pumpApp(
        BlocProvider.value(value: counterCubit, child: const CounterView()),
      );
      expect(find.text('$state'), findsOneWidget);
    });

    testWidgets('calls increment when increment button is tapped', (
      tester,
    ) async {
      when(() => counterCubit.state).thenReturn(0);
      when(() => counterCubit.increment()).thenReturn(null);
      await tester.pumpApp(
        BlocProvider.value(value: counterCubit, child: const CounterView()),
      );
      await tester.tap(find.byIcon(Icons.add));
      verify(() => counterCubit.increment()).called(1);
    });

    testWidgets('calls decrement when decrement button is tapped', (
      tester,
    ) async {
      when(() => counterCubit.state).thenReturn(0);
      when(() => counterCubit.decrement()).thenReturn(null);
      await tester.pumpApp(
        BlocProvider.value(value: counterCubit, child: const CounterView()),
      );
      await tester.tap(find.byIcon(Icons.remove));
      verify(() => counterCubit.decrement()).called(1);
    });

    testWidgets('calls reset when reset button is tapped', (
      tester,
    ) async {
      when(() => counterCubit.state).thenReturn(0);
      when(() => counterCubit.reset()).thenReturn(null);
      await tester.pumpApp(
        BlocProvider.value(value: counterCubit, child: const CounterView()),
      );
      await tester.tap(find.byIcon(Icons.refresh));
      verify(() => counterCubit.reset()).called(1);
    });

    testWidgets('has storage icon in app bar', (tester) async {
      when(() => counterCubit.state).thenReturn(0);
      await tester.pumpApp(
        BlocProvider.value(value: counterCubit, child: const CounterView()),
      );

      expect(find.byIcon(Icons.storage), findsOneWidget);
    });

    testWidgets('has storage icon that can be tapped', (
      tester,
    ) async {
      when(() => counterCubit.state).thenReturn(0);
      await tester.pumpApp(
        BlocProvider.value(value: counterCubit, child: const CounterView()),
      );

      // Verify storage icon exists and is tappable
      expect(find.byIcon(Icons.storage), findsOneWidget);
      
      // Just verify we can tap it without completing navigation
      // (to avoid drift database timer issues in this test)
      final iconButtonFinder = find.ancestor(
        of: find.byIcon(Icons.storage),
        matching: find.byType(IconButton),
      );
      expect(tester.widget<IconButton>(iconButtonFinder).onPressed, isNotNull);
    });
  });
}
