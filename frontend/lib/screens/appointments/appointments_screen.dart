import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:frontend/screens/appointments/add_appointment_screen.dart';
import 'package:frontend/services/appointment_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/appointment.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/widgets/error_widget.dart';
import 'package:frontend/widgets/loading_widget.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late Future<List<Appointment>> _appointmentsFuture;
  late Future<List<Appointment>> _upcomingAppointmentsFuture;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final appointmentService = AppointmentService(authProvider.token!);
    _appointmentsFuture = appointmentService.getAppointments();
    _upcomingAppointmentsFuture = appointmentService.getUpcomingAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rendez-vous'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'À venir'),
              Tab(text: 'Tous'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAppointmentScreen(),
                  ),
                );
                _loadAppointments();
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<Appointment>>(
              future: _upcomingAppointmentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                } else if (snapshot.hasError) {
                  return ErrorWidget(
                    message: snapshot.error.toString(),
                    onRetry: _loadAppointments,
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const ErrorWidget(message: 'Aucun rendez-vous à venir');
                }

                return _buildAppointmentsList(snapshot.data!);
              },
            ),
            FutureBuilder<List<Appointment>>(
              future: _appointmentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                } else if (snapshot.hasError) {
                  return ErrorWidget(
                    message: snapshot.error.toString(),
                    onRetry: _loadAppointments,
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const ErrorWidget(message: 'Aucun rendez-vous trouvé');
                }

                return _buildAppointmentsList(snapshot.data!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(List<Appointment> appointments) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(appointment.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appointment.description),
                Text(DateFormat('dd/MM/yyyy HH:mm').format(appointment.appointmentDate)),
                if (appointment.reminderSet)
                  const Text('Rappel activé', style: TextStyle(color: Colors.green)),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    // Implement edit functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    // Implement delete functionality
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}