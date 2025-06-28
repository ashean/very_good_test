import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/drift_test/drift_database.dart';
import 'package:my_app/drift_test/drift_test_page.dart';

void main() {
  group('DriftTestPage', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    testWidgets('renders correctly with initial state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: DriftTestPage(database: database)),
      );

      expect(find.text('Drift Test'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: DriftTestPage(database: database)),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty message when no items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: DriftTestPage(database: database)),
      );

      await tester.pumpAndSettle();

      expect(find.text('No items yet. Tap + to add one!'), findsOneWidget);
    });

    testWidgets('can add items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: DriftTestPage(database: database)),
      );

      await tester.pumpAndSettle();

      // Tap the add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Should show a list item now
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.textContaining('Item 1'), findsOneWidget);
    });
  });
}
