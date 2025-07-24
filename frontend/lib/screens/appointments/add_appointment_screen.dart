import 'package:flutter/material.dart';
import 'package:frontend/models/appointment.dart';
import 'package:intl/intl.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/appointment_service.dart';
import 'package:provider/provider.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({Key? key}) : super(key: key);

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _appointmentDate = DateTime.now();
  bool _reminderSet = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _appointmentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_appointmentDate),
      );
      if (pickedTime != null) {
        setState(() {
          _appointmentDate = DateTime(
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
    final appointmentService = AppointmentService(authProvider.token!);

    final appointment = Appointment(
      id: 0,
      title: _titleController.text,
      description: _descriptionController.text,
      appointmentDate: _appointmentDate,
      reminderSet: _reminderSet,
    );

    try {
      await appointmentService.addAppointment(appointment);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add appointment: ${e.toString()}'),
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
        title: const Text('Ajouter un rendez-vous'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => _selectDateTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date et heure'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd/MM/yyyy HH:mm').format(_appointmentDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Activer le rappel'),
                value: _reminderSet,
                onChanged: (value) {
                  setState(() {
                    _reminderSet = value;
                  });
                },
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