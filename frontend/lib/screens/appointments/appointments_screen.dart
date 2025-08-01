import 'package:flutter/material.dart';
import 'package:frontend/models/appointment.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/appointments/add_appointment_screen.dart';
import 'package:frontend/services/appointment_service.dart';
import 'package:frontend/widgets/appointment_tile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Appointment>> _appointmentsFuture;
  late Future<List<Appointment>> _upcomingAppointmentsFuture;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAppointments();
  }

  void _loadAppointments() {
    setState(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final service = AppointmentService(authProvider.token!);
      _appointmentsFuture = service.getAppointments();
      _upcomingAppointmentsFuture = service.getUpcomingAppointments();
    });
  }

  Future<void> _handleAddAppointment() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddAppointmentScreen()),
    );
    if (result == true) _refreshKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendez-vous'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'À venir'), Tab(text: 'Tous')],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _handleAddAppointment,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAppointments,
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: () async => _loadAppointments(),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAppointmentsList(_upcomingAppointmentsFuture),
            _buildAppointmentsList(_appointmentsFuture),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(Future<List<Appointment>> future) {
    return FutureBuilder<List<Appointment>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucun rendez-vous trouvé'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (_, index) => AppointmentTile(
            appointment: snapshot.data![index],
            onEdit: () => _handleEditAppointment(snapshot.data![index]),
            onDelete: () => _handleDeleteAppointment(snapshot.data![index].id),
          ),
        );
      },
    );
  }

  Future<void> _handleEditAppointment(Appointment appointment) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddAppointmentScreen(appointment: appointment),
      ),
    );
    if (result == true) _loadAppointments();
  }

  Future<void> _handleDeleteAppointment(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer'),
        content: const Text('Supprimer ce rendez-vous ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Oui', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final service = AppointmentService(authProvider.token!);
        await service.deleteAppointment(id);
        _loadAppointments();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rendez-vous supprimé !')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }
}