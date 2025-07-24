import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:frontend/models/medical_test.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/medical_tests/add_medical_test_screen.dart';
import 'package:frontend/services/medical_test_service.dart';
import 'package:frontend/widgets/loading_widget.dart';
import 'package:frontend/widgets/error_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MedicalTestsScreen extends StatefulWidget {
  const MedicalTestsScreen({Key? key}) : super(key: key);

  @override
  _MedicalTestsScreenState createState() => _MedicalTestsScreenState();
}

class _MedicalTestsScreenState extends State<MedicalTestsScreen> {
  late Future<List<MedicalTest>> _medicalTestsFuture;

  @override
  void initState() {
    super.initState();
    _loadMedicalTests();
  }

  void _loadMedicalTests() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final medicalTestService = MedicalTestService(authProvider.token!);
    _medicalTestsFuture = medicalTestService.getMedicalTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilans médicaux'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMedicalTestScreen(),
                ),
              );
              _loadMedicalTests();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MedicalTest>>(
        future: _medicalTestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasError) {
            return ErrorWidget(
              message: snapshot.error.toString(),
              onRetry: _loadMedicalTests,
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const ErrorWidget(message: 'Aucun bilan médical trouvé');
          }

          final medicalTests = snapshot.data!;

          return ListView.builder(
            itemCount: medicalTests.length,
            itemBuilder: (context, index) {
              final test = medicalTests[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(test.testName),
                  subtitle: Text('${test.testType} - ${DateFormat('dd/MM/yyyy').format(test.testDate)}'),
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