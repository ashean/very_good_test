import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import 'package:my_app/core/logging/app_logger.dart';
import 'package:my_app/drift_test/drift_database.dart';

class DriftTestPage extends StatefulWidget {
  const DriftTestPage({super.key, this.database});

  final AppDatabase? database;

  @override
  State<DriftTestPage> createState() => _DriftTestPageState();
}

class _DriftTestPageState extends State<DriftTestPage> {
  late final AppDatabase database;
  late final bool shouldCloseDatabase;
  List<TodoItem> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.database != null) {
      database = widget.database!;
      shouldCloseDatabase = false;
    } else {
      database = AppDatabase();
      shouldCloseDatabase = true;
    }
    _loadItems();
  }

  @override
  void dispose() {
    if (shouldCloseDatabase) {
      database.close();
    }
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() => isLoading = true);
    try {
      final allItems = await database.select(database.todoItems).get();
      setState(() {
        items = allItems;
        isLoading = false;
      });
    } on Exception catch (e, stackTrace) {
      AppLogger.logError(
        'Failed to load todo items',
        e,
        stackTrace,
        'DriftTestPage',
      );
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading items: $e')),
        );
      }
    }
  }

  Future<void> _addItem() async {
    try {
      await database
          .into(database.todoItems)
          .insert(
            TodoItemsCompanion.insert(
              title: 'Item ${items.length + 1}',
              content: 'Test content ${DateTime.now().millisecondsSinceEpoch}',
              createdAt: Value(DateTime.now()),
            ),
          );
      await _loadItems();
    } on Exception catch (e, stackTrace) {
      AppLogger.logError(
        'Failed to add todo item',
        e,
        stackTrace,
        'DriftTestPage',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding item: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drift Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadItems,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? const Center(
              child: Text('No items yet. Tap + to add one!'),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.content),
                  trailing: Text('ID: ${item.id}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
