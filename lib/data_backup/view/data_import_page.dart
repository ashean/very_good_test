import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_app/data_backup/cubit/data_backup_cubit.dart';
import 'package:my_app/data_backup/cubit/data_backup_state.dart';
import 'package:my_app/data_backup/service/backup_service.dart';
import 'package:my_app/drift_test/drift_database.dart';

class DataImportPage extends StatelessWidget {
  const DataImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataBackupCubit(
        BackupService(AppDatabase()),
      ),
      child: const DataImportView(),
    );
  }
}

class DataImportView extends StatefulWidget {
  const DataImportView({super.key});

  @override
  State<DataImportView> createState() => _DataImportViewState();
}

class _DataImportViewState extends State<DataImportView> {
  final _formKey = GlobalKey<FormState>();
  final _jsonController = TextEditingController();

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Data'),
      ),
      body: BlocConsumer<DataBackupCubit, DataBackupState>(
        listener: (context, state) {
          if (state is DataBackupImportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data imported successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            _jsonController.clear();
            context.read<DataBackupCubit>().resetToInitial();
          } else if (state is DataBackupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Import failed: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning, color: Colors.orange),
                              SizedBox(width: 8),
                              Text(
                                'Important Notes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Import Requirements:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('• Database must be empty for import'),
                          Text(
                            '• JSON must be from the same schema version',
                          ),
                          Text('• All existing data will be replaced'),
                          SizedBox(height: 12),
                          Text(
                            'Paste the exported JSON data into the text area '
                            'below.',
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
                  const Text(
                    'JSON Data:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _jsonController,
                      decoration: const InputDecoration(
                        hintText: 'Paste your exported JSON data here...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter JSON data';
                        }

                        try {
                          final decoded =
                              jsonDecode(value) as Map<String, dynamic>;

                          if (!decoded.containsKey('version') ||
                              !decoded.containsKey('schemaVersion') ||
                              !decoded.containsKey('data')) {
                            return 'Invalid backup format - missing required '
                                'fields';
                          }

                          final data = decoded['data'] as Map<String, dynamic>;
                          if (!data.containsKey('todoItems') ||
                              !data.containsKey('userProfiles') ||
                              !data.containsKey('bloodTestResults')) {
                            return 'Invalid backup format - missing data '
                                'tables';
                          }
                        } on FormatException {
                          return 'Invalid JSON format';
                        } on Exception {
                          return 'Invalid backup data structure';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: state is DataBackupLoading ? null : _importData,
                    icon: state is DataBackupLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.file_upload),
                    label: Text(
                      state is DataBackupLoading
                          ? 'Importing...'
                          : 'Import Data',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _importData() {
    if (_formKey.currentState?.validate() ?? false) {
      final jsonString = _jsonController.text.trim();
      context.read<DataBackupCubit>().importData(jsonString);
    }
  }
}
