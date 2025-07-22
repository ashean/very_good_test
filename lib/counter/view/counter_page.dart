import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_app/counter/counter.dart';
import 'package:my_app/data_backup/view/data_export_page.dart';
import 'package:my_app/data_backup/view/data_import_page.dart';
import 'package:my_app/drift_test/drift_test_page.dart';
import 'package:my_app/l10n/l10n.dart';
import 'package:my_app/user_profile/user_profile.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.counterAppBarTitle),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const UserProfileFormPage(),
              ),
            ),
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Profile',
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const UserProfileListPage(),
              ),
            ),
            icon: const Icon(Icons.people),
            tooltip: 'View Profiles',
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const DriftTestPage(),
              ),
            ),
            icon: const Icon(Icons.storage),
            tooltip: 'Database Test',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.backup),
            tooltip: 'Data Backup',
            onSelected: (value) {
              if (value == 'export') {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const DataExportPage(),
                  ),
                );
              } else if (value == 'import') {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const DataImportPage(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download),
                    SizedBox(width: 8),
                    Text('Export Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.file_upload),
                    SizedBox(width: 8),
                    Text('Import Data'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: const Center(child: CounterText()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'reset',
            onPressed: () => context.read<CounterCubit>().reset(),
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
