import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:provider/provider.dart';
import 'package:frontend/models/medication.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/medications/add_medication_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  void _loadMedications() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final medicationService = MedicationService(authProvider.token!);
    _medicationsFuture = medicationService.getMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Médicaments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMedicationScreen(),
                ),
              );
              _loadMedications();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Medication>>(
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
            return const ErrorWidget(message: 'Aucun médicament trouvé');
          }

          final medications = snapshot.data!;

          return ListView.builder(
            itemCount: medications.length,
            itemBuilder: (context, index) {
              final medication = medications[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(medication.name),
                  subtitle: Text('${medication.dosage} - ${medication.form}'),
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
        },
      ),
    );
  }
}