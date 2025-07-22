import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_app/data_backup/cubit/data_backup_cubit.dart';
import 'package:my_app/data_backup/cubit/data_backup_state.dart';
import 'package:my_app/data_backup/service/backup_service.dart';
import 'package:my_app/drift_test/drift_database.dart';

class DataExportPage extends StatelessWidget {
  const DataExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataBackupCubit(
        BackupService(AppDatabase()),
      ),
      child: const DataExportView(),
    );
  }
}

class DataExportView extends StatefulWidget {
  const DataExportView({super.key});

  @override
  State<DataExportView> createState() => _DataExportViewState();
}

class _DataExportViewState extends State<DataExportView> {
  String? _exportedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Data'),
      ),
      body: BlocConsumer<DataBackupCubit, DataBackupState>(
        listener: (context, state) {
          if (state is DataBackupExportSuccess) {
            setState(() {
              _exportedData = state.jsonData;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data exported successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is DataBackupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Export failed: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.blue),
                            const SizedBox(width: 8),
                            const Text(
                              'Export Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'This will export all your data including:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text('• Todo items'),
                        const Text('• User profiles'),
                        const Text('• Blood test results'),
                        const SizedBox(height: 12),
                        const Text(
                          'The exported data will be in JSON format that '
                          'copy and save as a backup file.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: state is DataBackupLoading
                      ? null
                      : () => context.read<DataBackupCubit>().exportData(),
                  icon: state is DataBackupLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.file_download),
                  label: Text(
                    state is DataBackupLoading ? 'Exporting...' : 'Export Data',
                  ),
                ),
                if (_exportedData != null) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Exported Data:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'JSON Data',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () => _copyToClipboard(context),
                                  icon: const Icon(Icons.copy),
                                  tooltip: 'Copy to Clipboard',
                                ),
                              ],
                            ),
                            const Divider(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: SelectableText(
                                  _exportedData!,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(context),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy to Clipboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    if (_exportedData != null) {
      await Clipboard.setData(ClipboardData(text: _exportedData!));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data copied to clipboard!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
