import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/medication.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/medication_service.dart';
import 'package:provider/provider.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({Key? key}) : super(key: key);

  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _formController = TextEditingController();
  final _timesPerDayController = TextEditingController();
  final List<TimeOfDay> _intakeTimes = [];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _formController.dispose();
    _timesPerDayController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _intakeTimes.add(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final medicationService = MedicationService(authProvider.token!);

    final medication = Medication(
      id: 0,
      name: _nameController.text,
      dosage: _dosageController.text,
      form: _formController.text,
      timesPerDay: int.parse(_timesPerDayController.text),
      intakeTimes: _intakeTimes
          .map((time) => DateTime(2023, 1, 1, time.hour, time.minute))
          .toList(),
    );

    try {
      await medicationService.addMedication(medication);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add medication: ${e.toString()}'),
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
        title: const Text('Ajouter un médicament'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom du médicament'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(labelText: 'Dosage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un dosage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _formController,
                decoration: const InputDecoration(labelText: 'Forme (comprimé, sirop, etc.)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une forme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _timesPerDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nombre de prises par jour'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nombre';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Heures de prise:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _intakeTimes.map((time) {
                  return Chip(
                    label: Text(DateFormat.Hm().format(
                      DateTime(2023, 1, 1, time.hour, time.minute),
                    )),
                    onDeleted: () {
                      setState(() {
                        _intakeTimes.remove(time);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: const Text('Ajouter une heure de prise'),
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