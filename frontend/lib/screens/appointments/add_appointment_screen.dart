import 'package:flutter/material.dart';
import 'package:frontend/models/appointment.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/appointment_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddAppointmentScreen extends StatefulWidget {
  final Appointment? appointment;

  const AddAppointmentScreen({Key? key, this.appointment}) : super(key: key);

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _appointmentDate;
  late bool _reminderSet;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.appointment?.title ?? '');
    _descriptionController = TextEditingController(text: widget.appointment?.description ?? '');
    _appointmentDate = widget.appointment?.appointmentDate ?? DateTime.now().add(Duration(hours: 1));
    _reminderSet = widget.appointment?.reminderSet ?? false;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _appointmentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final service = AppointmentService(authProvider.token!);

      final appointment = Appointment(
        id: widget.appointment?.id ?? 0,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        appointmentDate: _appointmentDate,
        reminderSet: _reminderSet,
      );

      if (widget.appointment == null) {
        await service.addAppointment(appointment);
      } else {
        await service.updateAppointment(appointment);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointment == null ? 'Ajouter' : 'Modifier'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Titre*'),
                      validator: (value) => 
                          value?.isEmpty ?? true ? 'Champ obligatoire' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectDateTime(context),
                      child: InputDecorator(
                        decoration: InputDecoration(labelText: 'Date/Heure'),
                        child: Row(
                          children: [
                            Text(DateFormat('dd/MM/yyyy HH:mm').format(_appointmentDate)),
                            Spacer(),
                            Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    SwitchListTile(
                      title: Text('Rappel'),
                      value: _reminderSet,
                      onChanged: (value) => setState(() => _reminderSet = value),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text('Enregistrer'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}