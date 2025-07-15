import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_app/blood_test/view/blood_test_form_page.dart';
import 'package:my_app/blood_test/view/blood_test_list_page.dart';
import 'package:my_app/drift_test/drift_database.dart';
import 'package:my_app/user_profile/cubit/user_profile_cubit.dart';
import 'package:my_app/user_profile/cubit/user_profile_state.dart';
import 'package:my_app/user_profile/repository/user_profile_repository.dart';
import 'package:my_app/user_profile/widgets/blood_test_summary.dart';

class UserProfileListPage extends StatelessWidget {
  const UserProfileListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileCubit(
        UserProfileRepository(AppDatabase()),
      )..loadUserProfiles(),
      child: const UserProfileListView(),
    );
  }
}

class UserProfileListView extends StatelessWidget {
  const UserProfileListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<UserProfileCubit>().loadUserProfiles(),
          ),
        ],
      ),
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserProfileListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading profiles',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<UserProfileCubit>().loadUserProfiles(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is UserProfileListLoaded) {
            if (state.profiles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No profiles yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first profile using the form!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.profiles.length,
              itemBuilder: (context, index) {
                final profile = state.profiles[index];
                return UserProfileCard(profile: profile);
              },
            );
          }

          return const Center(
            child: Text('Welcome! Load profiles to get started.'),
          );
        },
      ),
    );
  }
}

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({required this.profile, super.key});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    profile.name.isNotEmpty
                        ? profile.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Created: ${_formatDate(profile.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text('ID: ${profile.id}'),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    context,
                    'Age',
                    '${profile.age} years',
                    Icons.cake,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    context,
                    'Height',
                    '${profile.heightCm.toStringAsFixed(1)} cm',
                    Icons.height,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    context,
                    'Weight',
                    '${profile.weightKg.toStringAsFixed(1)} kg',
                    Icons.monitor_weight,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    context,
                    'BMI',
                    _calculateBMI(profile.heightCm, profile.weightKg),
                    Icons.analytics,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BloodTestSummary(userProfileId: profile.id),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => BloodTestListPage(
                            userProfileId: profile.id,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.biotech, size: 16),
                    label: const Text('Blood Tests'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => BloodTestFormPage(
                            userProfileId: profile.id,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Test'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _calculateBMI(double heightCm, double weightKg) {
    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);
    return bmi.toStringAsFixed(1);
  }
}
