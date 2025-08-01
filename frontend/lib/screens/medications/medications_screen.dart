import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:frontend/screens/medications/add_medication_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/medication.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/medication_service.dart';
import 'package:frontend/widgets/error_widget.dart';
import 'package:frontend/widgets/loading_widget.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({Key? key}) : super(key: key);

  @override
  _MedicationsScreenState createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  late Future<List<Medication>> _medicationsFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    setState(() {
      final authProvider = context.read<AuthProvider>();
      _medicationsFuture = MedicationService(authProvider.token!)
          .getMedications()
          .catchError((error) {
        throw error;
      });
    });
  }

  Future<void> _navigateToAddScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditMedicationScreen(),
        fullscreenDialog: true,
      ),
    );

    if (result == true) {
      // Trigger refresh after adding
      _refreshIndicatorKey.currentState?.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddScreen(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _loadMedications,
        child: FutureBuilder<List<Medication>>(
          future: _medicationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            } else if (snapshot.hasError) {
              return ErrorWidget(
                message: snapshot.error.toString(),
                onRetry: _loadMedications,
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const ErrorWidget(message: 'No medications found');
            }

            return _buildMedicationList(snapshot.data!);
          },
        ),
      ),
    );
  }

  Widget _buildMedicationList(List<Medication> medications) {
    return ListView.builder(
      itemCount: medications.length,
      itemBuilder: (context, index) {
        final medication = medications[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(medication.name),
            subtitle: Text('${medication.dosage} - ${medication.form}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToEditScreen(context, medication),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteMedication(medication.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToEditScreen(
      BuildContext context, Medication medication) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMedicationScreen(medication: medication),
      ),
    );

    if (result == true) {
      _loadMedications();
    }
  }

  Future<void> _deleteMedication(int id) async {
    try {
      final authProvider = context.read<AuthProvider>();
      await MedicationService(authProvider.token!).deleteMedication(id);
      _loadMedications();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medication deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: ${e.toString()}')),
      );
    }
  }
}