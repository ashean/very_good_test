import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_app/blood_test/cubit/blood_test_cubit.dart';
import 'package:my_app/blood_test/cubit/blood_test_state.dart';
import 'package:my_app/blood_test/repository/blood_test_repository.dart';
import 'package:my_app/drift_test/drift_database.dart';

class BloodTestFormPage extends StatelessWidget {
  const BloodTestFormPage({
    required this.userProfileId,
    super.key,
    this.database,
  });

  final int userProfileId;
  final AppDatabase? database;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BloodTestCubit(
        BloodTestRepository(database ?? AppDatabase()),
      ),
      child: BloodTestFormView(userProfileId: userProfileId),
    );
  }
}

class BloodTestFormView extends StatefulWidget {
  const BloodTestFormView({required this.userProfileId, super.key});

  final int userProfileId;

  @override
  State<BloodTestFormView> createState() => _BloodTestFormViewState();
}

class _BloodTestFormViewState extends State<BloodTestFormView> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _testDate;
  final _totalCholesterolController = TextEditingController();
  final _hdlCholesterolController = TextEditingController();
  final _ldlCholesterolController = TextEditingController();
  final _triglyceridesController = TextEditingController();
  final _fastingGlucoseController = TextEditingController();
  final _hba1cController = TextEditingController();

  @override
  void dispose() {
    _totalCholesterolController.dispose();
    _hdlCholesterolController.dispose();
    _ldlCholesterolController.dispose();
    _triglyceridesController.dispose();
    _fastingGlucoseController.dispose();
    _hba1cController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _testDate = null;
    });
    _totalCholesterolController.clear();
    _hdlCholesterolController.clear();
    _ldlCholesterolController.clear();
    _triglyceridesController.clear();
    _fastingGlucoseController.clear();
    _hba1cController.clear();
  }

  double? _parseDouble(String value) {
    if (value.isEmpty) return null;
    return double.tryParse(value);
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<BloodTestCubit>().submitBloodTestResult(
        userProfileId: widget.userProfileId,
        testDate: _testDate!,
        totalCholesterol: _parseDouble(_totalCholesterolController.text),
        hdlCholesterol: _parseDouble(_hdlCholesterolController.text),
        ldlCholesterol: _parseDouble(_ldlCholesterolController.text),
        triglycerides: _parseDouble(_triglyceridesController.text),
        fastingGlucose: _parseDouble(_fastingGlucoseController.text),
        hba1c: _parseDouble(_hba1cController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Test Results'),
      ),
      body: BlocConsumer<BloodTestCubit, BloodTestState>(
        listener: (context, state) {
          if (state is BloodTestFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Blood test results saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is BloodTestFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BloodTestLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BloodTestFormSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Blood test results saved successfully!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _resetForm();
                      context.read<BloodTestCubit>().resetToInitial();
                    },
                    child: const Text('Add Another'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Test Date
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Test Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _testDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _testDate = date;
                        });
                      }
                    },
                    validator: (value) {
                      if (_testDate == null) {
                        return 'Please select a test date';
                      }
                      return null;
                    },
                    controller: TextEditingController(
                      text: _testDate?.toString().split(' ')[0] ?? '',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Total Cholesterol
                  TextFormField(
                    key: const Key('totalCholesterolField'),
                    controller: _totalCholesterolController,
                    decoration: const InputDecoration(
                      labelText: 'Total Cholesterol (mg/dL)',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // HDL Cholesterol
                  TextFormField(
                    key: const Key('hdlCholesterolField'),
                    controller: _hdlCholesterolController,
                    decoration: const InputDecoration(
                      labelText: 'HDL Cholesterol (mg/dL)',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // LDL Cholesterol
                  TextFormField(
                    key: const Key('ldlCholesterolField'),
                    controller: _ldlCholesterolController,
                    decoration: const InputDecoration(
                      labelText: 'LDL Cholesterol (mg/dL)',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Triglycerides
                  TextFormField(
                    key: const Key('triglyceridesField'),
                    controller: _triglyceridesController,
                    decoration: const InputDecoration(
                      labelText: 'Triglycerides (mg/dL)',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Fasting Glucose
                  TextFormField(
                    key: const Key('fastingGlucoseField'),
                    controller: _fastingGlucoseController,
                    decoration: const InputDecoration(
                      labelText: 'Fasting Glucose (mg/dL)',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // HbA1c
                  TextFormField(
                    key: const Key('hba1cField'),
                    controller: _hba1cController,
                    decoration: const InputDecoration(
                      labelText: 'HbA1c (%)',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    key: const Key('saveResultsButton'),
                    onPressed: _submitForm,
                    child: const Text('Save Results'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
