import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:my_app/persistence/submission_repository.dart';
import 'package:my_app/submissions/cubit/submissions_cubit.dart';

class SubmissionsPage extends StatelessWidget {
  const SubmissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubmissionsCubit()..loadSubmissions(),
      child: const SubmissionsView(),
    );
  }
}

class SubmissionsView extends StatelessWidget {
  const SubmissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submissions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<SubmissionsCubit>().loadSubmissions(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_all') {
                _showClearAllDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_all',
                child: Text('Clear All'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<SubmissionsCubit, SubmissionsState>(
        builder: (context, state) {
          if (state is SubmissionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubmissionsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<SubmissionsCubit>().loadSubmissions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SubmissionsLoaded) {
            if (state.submissions.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No submissions yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.submissions.length,
              itemBuilder: (context, index) {
                final submission = state.submissions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(submission.text),
                    subtitle: Text(
                      DateFormat(
                        'MMM d, y at h:mm a',
                      ).format(submission.submittedAt),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteDialog(context, submission),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Submission submission) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Submission'),
        content: Text('Are you sure you want to delete "${submission.text}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SubmissionsCubit>().deleteSubmission(submission.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Submissions'),
        content: const Text(
          'Are you sure you want to delete all submissions? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SubmissionsCubit>().clearAllSubmissions();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
