import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_app/drift_test/drift_database.dart';
import 'package:my_app/user_profile/cubit/user_profile_cubit.dart';
import 'package:my_app/user_profile/cubit/user_profile_state.dart';
import 'package:my_app/user_profile/repository/user_profile_repository.dart';
import 'package:my_app/user_profile/view/user_profile_list_page.dart';

class UserProfileFormPage extends StatelessWidget {
  const UserProfileFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileCubit(
        UserProfileRepository(AppDatabase()),
      ),
      child: const UserProfileFormView(),
    );
  }
}

class UserProfileFormView extends StatefulWidget {
  const UserProfileFormView({super.key});

  @override
  State<UserProfileFormView> createState() => _UserProfileFormViewState();
}

class _UserProfileFormViewState extends State<UserProfileFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile Form'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const UserProfileListPage(),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            _clearForm();
            context.read<UserProfileCubit>().resetToInitial();
          } else if (state is UserProfileFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
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
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your full name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      if (value.trim().length > 100) {
                        return 'Name must be 100 characters or less';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      hintText: 'Enter your age',
                      border: OutlineInputBorder(),
                      suffixText: 'years',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Age is required';
                      }
                      final age = int.tryParse(value);
                      if (age == null) {
                        return 'Please enter a valid age';
                      }
                      if (age < 1 || age > 150) {
                        return 'Age must be between 1 and 150';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      labelText: 'Height',
                      hintText: 'Enter your height',
                      border: OutlineInputBorder(),
                      suffixText: 'cm',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Height is required';
                      }
                      final height = double.tryParse(value);
                      if (height == null) {
                        return 'Please enter a valid height';
                      }
                      if (height < 30 || height > 300) {
                        return 'Height must be between 30 and 300 cm';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      hintText: 'Enter your weight',
                      border: OutlineInputBorder(),
                      suffixText: 'kg',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Weight is required';
                      }
                      final weight = double.tryParse(value);
                      if (weight == null) {
                        return 'Please enter a valid weight';
                      }
                      if (weight < 1 || weight > 1000) {
                        return 'Weight must be between 1 and 1000 kg';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is UserProfileLoading ? null : _submitForm,
                    child: state is UserProfileLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Profile'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final age = int.parse(_ageController.text);
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);

      context.read<UserProfileCubit>().submitUserProfile(
        name: name,
        age: age,
        heightCm: height,
        weightKg: weight,
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _ageController.clear();
    _heightController.clear();
    _weightController.clear();
  }
}
