import 'package:flutter/material.dart';
import 'package:frontend/models/medical_test.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/medical_test_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddMedicalTestScreen extends StatefulWidget {
  const AddMedicalTestScreen({Key? key}) : super(key: key);

  @override
  _AddMedicalTestScreenState createState() => _AddMedicalTestScreenState();
}

class _AddMedicalTestScreenState extends State<AddMedicalTestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testNameController = TextEditingController();
  final _resultController = TextEditingController();
  String _testType = 'Biologie';
  DateTime _testDate = DateTime.now();

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
    if (picked != null) {
      setState(() {
        _testDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final medicalTestService = MedicalTestService(authProvider.token!);

    final medicalTest = MedicalTest(
      id: 0,
      testType: _testType,
      testName: _testNameController.text,
      result: _resultController.text,
      filePath: '', // You would implement file upload separately
      testDate: _testDate,
    );

    try {
      await medicalTestService.addMedicalTest(medicalTest);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add medical test: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un bilan médical'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _testType,
                decoration: const InputDecoration(labelText: 'Type de bilan'),
                items: const [
                  DropdownMenuItem(value: 'Biologie', child: Text('Biologie')),
                  DropdownMenuItem(value: 'Radiologie', child: Text('Radiologie')),
                  DropdownMenuItem(value: 'Autre', child: Text('Autre')),
                ],
                onChanged: (value) {
                  setState(() {
                    _testType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _testNameController,
                decoration: const InputDecoration(labelText: 'Nom du bilan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _resultController,
                decoration: const InputDecoration(labelText: 'Résultat'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date du bilan'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd/MM/yyyy').format(_testDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement file upload
                },
                child: const Text('Ajouter un fichier'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}