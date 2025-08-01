import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/medication.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/medication_service.dart';
import 'package:frontend/utils/validators.dart';
import 'package:frontend/widgets/time_picker_chip.dart';
import 'package:provider/provider.dart';

class AddEditMedicationScreen extends StatefulWidget {
  final Medication? medication;

  const AddEditMedicationScreen({Key? key, this.medication}) : super(key: key);

  @override
  _AddEditMedicationScreenState createState() => _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState extends State<AddEditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dosageController;
  late final TextEditingController _formController;
  late final TextEditingController _timesPerDayController;
  final List<TimeOfDay> _intakeTimes = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dosageController = TextEditingController();
    _formController = TextEditingController();
    _timesPerDayController = TextEditingController();

    if (widget.medication != null) {
      _initializeFormWithMedication(widget.medication!);
    }
  }

  void _initializeFormWithMedication(Medication medication) {
    _nameController.text = medication.name;
    _dosageController.text = medication.dosage;
    _formController.text = medication.form;
    _timesPerDayController.text = medication.timesPerDay.toString();
    _intakeTimes.addAll(
      medication.intakeTimes
          .map((time) => TimeOfDay(hour: time.hour, minute: time.minute)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _formController.dispose();
    _timesPerDayController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && !_intakeTimes.contains(picked)) {
      setState(() {
        _intakeTimes.add(picked);
        _intakeTimes.sort((a, b) {
          if (a.hour == b.hour) return a.minute.compareTo(b.minute);
          return a.hour.compareTo(b.hour);
        });
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_intakeTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one intake time')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final medicationService = MedicationService(authProvider.token!);

      final medication = Medication(
        id: widget.medication?.id ?? 0,
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        form: _formController.text.trim(),
        timesPerDay: int.parse(_timesPerDayController.text),
        intakeTimes: _intakeTimes
            .map((time) => DateTime(2023, 1, 1, time.hour, time.minute))
            .toList(),
      );

      if (widget.medication == null) {
        await medicationService.addMedication(medication);
      } else {
        await medicationService.updateMedication(medication);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medication == null ? 'Add Medication' : 'Edit Medication'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Medication Name'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(labelText: 'Dosage'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _formController,
                decoration: const InputDecoration(labelText: 'Form'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _timesPerDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Times per day'),
                validator: Validators.numberValidator,
              ),
              const SizedBox(height: 20),
              const Text('Intake Times:'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _intakeTimes.map((time) {
                  return TimePickerChip(
                    time: time,
                    onDeleted: () => setState(() => _intakeTimes.remove(time)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectTime,
                child: const Text('Add Intake Time'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Save Medication'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}