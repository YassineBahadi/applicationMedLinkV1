import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/clinical_data.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/clinical_data_service.dart';
import 'package:frontend/utils/validators.dart';

class AddEditClinicalDataScreen extends StatefulWidget {
  final ClinicalData? clinicalData;

  const AddEditClinicalDataScreen({
    Key? key,
    this.clinicalData,
  }) : super(key: key);

  @override
  _AddEditClinicalDataScreenState createState() => _AddEditClinicalDataScreenState();
}

class _AddEditClinicalDataScreenState extends State<AddEditClinicalDataScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _parameterTypeController;
  late final TextEditingController _valueController;
  late DateTime _recordedAt;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _parameterTypeController = TextEditingController();
    _valueController = TextEditingController();
    _recordedAt = DateTime.now();

    if (widget.clinicalData != null) {
      _initializeFormWithData(widget.clinicalData!);
    }
  }

  void _initializeFormWithData(ClinicalData data) {
    _parameterTypeController.text = data.parameterType;
    _valueController.text = data.value.toString();
    _recordedAt = data.recordedAt;
  }

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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final service = ClinicalDataService(authProvider.token!);

      final clinicalData = ClinicalData(
        id: widget.clinicalData?.id ?? 0,
        parameterType: _parameterTypeController.text.trim(),
        value: double.parse(_valueController.text.trim()),
        recordedAt: _recordedAt,
      );

      if (widget.clinicalData == null) {
        await service.addClinicalData(clinicalData);
      } else {
        await service.updateClinicalData(clinicalData);
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
        title: Text(widget.clinicalData == null 
            ? 'Add Clinical Data' 
            : 'Edit Clinical Data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _parameterTypeController.text.isEmpty 
                    ? null 
                    : _parameterTypeController.text,
                decoration: const InputDecoration(labelText: 'Parameter Type'),
                items: const [
                  DropdownMenuItem(value: 'Poids', child: Text('Poids (kg)')),
                  DropdownMenuItem(value: 'Tension', child: Text('Tension artérielle')),
                  DropdownMenuItem(value: 'Glycémie', child: Text('Glycémie (mg/dL)')),
                  DropdownMenuItem(value: 'Diurèse', child: Text('Diurèse (mL)')),
                  DropdownMenuItem(value: 'Température', child: Text('Température (°C)')),
                  DropdownMenuItem(value: 'Saturation', child: Text('Saturation (%)')),
                  DropdownMenuItem(value: 'Fréquence cardiaque', child: Text('Fréquence cardiaque (bpm)')),
                ],
                onChanged: (value) => _parameterTypeController.text = value ?? '',
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Value'),
                validator: Validators.numberValidator,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => _selectDateTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date & Time'),
                  child: Row(
                    children: [
                      Text(DateFormat('dd/MM/yyyy HH:mm').format(_recordedAt)),
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
                    : Text(widget.clinicalData == null ? 'SAVE' : 'UPDATE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}