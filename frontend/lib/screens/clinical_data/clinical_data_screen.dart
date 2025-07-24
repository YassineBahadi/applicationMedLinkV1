import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:frontend/screens/clinical_data/add_clinical_data_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/clinical_data.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/clinical_data_service.dart';
import 'package:frontend/widgets/error_widget.dart';
import 'package:frontend/widgets/loading_widget.dart';

class ClinicalDataScreen extends StatefulWidget {
  const ClinicalDataScreen({Key? key}) : super(key: key);

  @override
  _ClinicalDataScreenState createState() => _ClinicalDataScreenState();
}

class _ClinicalDataScreenState extends State<ClinicalDataScreen> {
  late Future<List<ClinicalData>> _clinicalDataFuture;

  @override
  void initState() {
    super.initState();
    _loadClinicalData();
  }

  void _loadClinicalData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final clinicalDataService = ClinicalDataService(authProvider.token!);
    _clinicalDataFuture = clinicalDataService.getClinicalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surveillance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddClinicalDataScreen(),
                ),
              );
              _loadClinicalData();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ClinicalData>>(
        future: _clinicalDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasError) {
            return ErrorWidget(
              message: snapshot.error.toString(),
              onRetry: _loadClinicalData,
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const ErrorWidget(message: 'Aucune donnée clinique trouvée');
          }

          final clinicalData = snapshot.data!;

          return ListView.builder(
            itemCount: clinicalData.length,
            itemBuilder: (context, index) {
              final data = clinicalData[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(data.parameterType),
                  subtitle: Text('Valeur: ${data.value} - ${DateFormat('dd/MM/yyyy HH:mm').format(data.recordedAt)}'),
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