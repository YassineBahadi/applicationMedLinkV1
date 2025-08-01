import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/medical_test.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/medical_test_service.dart';
import 'package:frontend/utils/validators.dart';

class AddEditMedicalTestScreen extends StatefulWidget {
  final MedicalTest? medicalTest;

  const AddEditMedicalTestScreen({
    Key? key,
    this.medicalTest,
  }) : super(key: key);

  @override
  _AddEditMedicalTestScreenState createState() => _AddEditMedicalTestScreenState();
}

class _AddEditMedicalTestScreenState extends State<AddEditMedicalTestScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _testNameController;
  late final TextEditingController _resultController;
  late String _testType;
  late DateTime _testDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _testNameController = TextEditingController();
    _resultController = TextEditingController();
    _testType = 'Biologie';
    _testDate = DateTime.now();

    if (widget.medicalTest != null) {
      _initializeFormWithTest(widget.medicalTest!);
    }
  }

  void _initializeFormWithTest(MedicalTest test) {
    _testNameController.text = test.testName;
    _resultController.text = test.result;
    _testType = test.testType;
    _testDate = test.testDate;
  }

  @override
  void dispose() {
    _testNameController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _testDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _testDate) {
      setState(() => _testDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final medicalTestService = MedicalTestService(authProvider.token!);

      final medicalTest = MedicalTest(
        id: widget.medicalTest?.id ?? 0,
        testType: _testType,
        testName: _testNameController.text.trim(),
        result: _resultController.text.trim(),
        testDate: _testDate,
      );

      if (widget.medicalTest == null) {
        await medicalTestService.addMedicalTest(medicalTest);
      } else {
        await medicalTestService.updateMedicalTest(medicalTest);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicalTest == null 
            ? 'Add Medical Test' 
            : 'Edit Medical Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _testType,
                decoration: const InputDecoration(labelText: 'Test Type'),
                items: const [
                  DropdownMenuItem(value: 'Biologie', child: Text('Biologie')),
                  DropdownMenuItem(value: 'Radiologie', child: Text('Radiologie')),
                  DropdownMenuItem(value: 'ECG', child: Text('ECG')),
                  DropdownMenuItem(value: 'Autre', child: Text('Autre')),
                ],
                onChanged: (value) => setState(() => _testType = value!),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _testNameController,
                decoration: const InputDecoration(labelText: 'Test Name'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _resultController,
                decoration: const InputDecoration(labelText: 'Result'),
                maxLines: 3,
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Test Date'),
                  child: Row(
                    children: [
                      Text(DateFormat('dd/MM/yyyy').format(_testDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : Text(widget.medicalTest == null ? 'SAVE' : 'UPDATE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}