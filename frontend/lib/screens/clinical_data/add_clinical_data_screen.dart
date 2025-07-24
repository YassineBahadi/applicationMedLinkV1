import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/clinical_data.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/clinical_data_service.dart';
import 'package:provider/provider.dart';

class AddClinicalDataScreen extends StatefulWidget {
  const AddClinicalDataScreen({Key? key}) : super(key: key);

  @override
  _AddClinicalDataScreenState createState() => _AddClinicalDataScreenState();
}

class _AddClinicalDataScreenState extends State<AddClinicalDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _parameterTypeController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _recordedAt = DateTime.now();

  @override
  void dispose() {
    _parameterTypeController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _recordedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_recordedAt),
      );
      if (pickedTime != null) {
        setState(() {
          _recordedAt = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final clinicalDataService = ClinicalDataService(authProvider.token!);

    final clinicalData = ClinicalData(
      id: 0,
      parameterType: _parameterTypeController.text,
      value: double.parse(_valueController.text),
      recordedAt: _recordedAt,
    );

    try {
      await clinicalDataService.addClinicalData(clinicalData);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add clinical data: ${e.toString()}'),
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
        title: const Text('Ajouter des données cliniques'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Type de paramètre'),
                items: const [
                  DropdownMenuItem(value: 'Poids', child: Text('Poids (kg)')),
                  DropdownMenuItem(value: 'Tension', child: Text('Tension artérielle')),
                  DropdownMenuItem(value: 'Glycémie', child: Text('Glycémie (mg/dL)')),
                  DropdownMenuItem(value: 'Diurèse', child: Text('Diurèse (mL)')),
                  DropdownMenuItem(value: 'Température', child: Text('Température (°C)')),
                  DropdownMenuItem(value: 'Saturation', child: Text('Saturation (%)')),
                  DropdownMenuItem(value: 'Fréquence cardiaque', child: Text('Fréquence cardiaque (bpm)')),
                ],
                onChanged: (value) {
                  _parameterTypeController.text = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner un type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valeur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une valeur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => _selectDateTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date et heure'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd/MM/yyyy HH:mm').format(_recordedAt)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
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