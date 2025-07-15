import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:my_app/blood_test/cubit/blood_test_cubit.dart';
import 'package:my_app/blood_test/cubit/blood_test_state.dart';
import 'package:my_app/blood_test/repository/blood_test_repository.dart';
import 'package:my_app/blood_test/view/blood_test_form_page.dart';
import 'package:my_app/drift_test/drift_database.dart';

class BloodTestListPage extends StatelessWidget {
  const BloodTestListPage({required this.userProfileId, super.key});

  final int userProfileId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BloodTestCubit(
        BloodTestRepository(AppDatabase()),
      )..loadBloodTestResults(userProfileId),
      child: BloodTestListView(userProfileId: userProfileId),
    );
  }
}

class BloodTestListView extends StatelessWidget {
  const BloodTestListView({required this.userProfileId, super.key});

  final int userProfileId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Test Results'),
      ),
      body: BlocBuilder<BloodTestCubit, BloodTestState>(
        builder: (context, state) {
          if (state is BloodTestLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BloodTestListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BloodTestCubit>().loadBloodTestResults(
                        userProfileId,
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is BloodTestListLoaded) {
            if (state.results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.biotech, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No blood test results yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your first blood test result to track your health',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => BloodTestFormPage(
                              userProfileId: userProfileId,
                            ),
                          ),
                        );
                      },
                      child: const Text('Add Blood Test Result'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final result = state.results[index];
                return BloodTestCard(
                  result: result,
                  onDelete: () {
                    context.read<BloodTestCubit>().deleteBloodTestResult(
                      result.id,
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => BloodTestFormPage(
                userProfileId: userProfileId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BloodTestCard extends StatelessWidget {
  const BloodTestCard({
    required this.result,
    required this.onDelete,
    super.key,
  });

  final BloodTestResult result;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Test Date: ${dateFormat.format(result.testDate)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (result.totalCholesterol != null)
              _buildResultRow(
                'Total Cholesterol',
                '${result.totalCholesterol} mg/dL',
              ),
            if (result.hdlCholesterol != null)
              _buildResultRow(
                'HDL Cholesterol',
                '${result.hdlCholesterol} mg/dL',
              ),
            if (result.ldlCholesterol != null)
              _buildResultRow(
                'LDL Cholesterol',
                '${result.ldlCholesterol} mg/dL',
              ),
            if (result.triglycerides != null)
              _buildResultRow('Triglycerides', '${result.triglycerides} mg/dL'),
            if (result.fastingGlucose != null)
              _buildResultRow(
                'Fasting Glucose',
                '${result.fastingGlucose} mg/dL',
              ),
            if (result.hba1c != null)
              _buildResultRow('HbA1c', '${result.hba1c}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
