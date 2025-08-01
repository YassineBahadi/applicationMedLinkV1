import 'package:flutter/material.dart';
import 'package:frontend/models/appointment.dart';
import 'package:intl/intl.dart';

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AppointmentTile({
    Key? key,
    required this.appointment,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(appointment.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appointment.description),
            SizedBox(height: 4),
            Text(DateFormat('dd/MM/yyyy HH:mm').format(appointment.appointmentDate)),
            if (appointment.reminderSet)
              Chip(
                label: Text('Rappel activé'),
                backgroundColor: Colors.green,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}