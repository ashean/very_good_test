import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_app/blood_test/cubit/blood_test_cubit.dart';
import 'package:my_app/blood_test/cubit/blood_test_state.dart';
import 'package:my_app/blood_test/repository/blood_test_repository.dart';
import 'package:my_app/drift_test/drift_database.dart';

class BloodTestSummary extends StatelessWidget {
  const BloodTestSummary({required this.userProfileId, super.key});

  final int userProfileId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BloodTestCubit(
        BloodTestRepository(AppDatabase()),
      )..loadBloodTestResults(userProfileId),
      child: BlocBuilder<BloodTestCubit, BloodTestState>(
        builder: (context, state) {
          if (state is BloodTestListLoaded) {
            if (state.results.isEmpty) {
              return const SizedBox.shrink();
            }

            final latestResult = state.results.first;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.biotech,
                        size: 16,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Latest Blood Test',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${state.results.length} test'
                        '${state.results.length > 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (latestResult.totalCholesterol != null)
                        _buildQuickStat(
                          context,
                          'Total Cholesterol',
                          '${latestResult.totalCholesterol}',
                          'mg/dL',
                        ),
                      if (latestResult.totalCholesterol != null &&
                          latestResult.fastingGlucose != null)
                        const SizedBox(width: 16),
                      if (latestResult.fastingGlucose != null)
                        _buildQuickStat(
                          context,
                          'Glucose',
                          '${latestResult.fastingGlucose}',
                          'mg/dL',
                        ),
                      if ((latestResult.totalCholesterol != null ||
                              latestResult.fastingGlucose != null) &&
                          latestResult.hba1c != null)
                        const SizedBox(width: 16),
                      if (latestResult.hba1c != null)
                        _buildQuickStat(
                          context,
                          'HbA1c',
                          '${latestResult.hba1c}',
                          '%',
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Test Date: ${_formatDate(latestResult.testDate)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is BloodTestLoading) {
            return Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Loading blood tests...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          // No blood tests or error - don't show anything
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    String label,
    String value,
    String unit,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: Colors.blue.shade600,
            ),
          ),
          RichText(
            text: TextSpan(
              text: value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
