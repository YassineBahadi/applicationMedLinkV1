import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:frontend/screens/clinical_data/add_clinical_data_screen.dart';
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadClinicalData();
  }

  Future<void> _loadClinicalData() async {
    setState(() {
      final authProvider = context.read<AuthProvider>();
      _clinicalDataFuture = ClinicalDataService(authProvider.token!)
          .getClinicalData();
    });
  }

  Future<void> _navigateToAddScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditClinicalDataScreen(),
      ),
    );

    if (result == true) {
      _refreshIndicatorKey.currentState?.show();
    }
  }

  Future<void> _navigateToEditScreen(BuildContext context, ClinicalData data) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditClinicalDataScreen(clinicalData: data),
      ),
    );

    if (result == true) {
      _loadClinicalData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Données Cliniques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Ajouter des données',
            onPressed: () => _navigateToAddScreen(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _loadClinicalData,
        child: FutureBuilder<List<ClinicalData>>(
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

            return _buildClinicalDataList(snapshot.data!);
          },
        ),
      ),
    );
  }

  Widget _buildClinicalDataList(List<ClinicalData> clinicalData) {
    return ListView.builder(
      itemCount: clinicalData.length,
      itemBuilder: (context, index) {
        final data = clinicalData[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(data.parameterType),
            subtitle: Text('${data.value} - ${data.formattedDate()}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                  tooltip: 'Modifier',
                  onPressed: () => _navigateToEditScreen(context, data),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  tooltip: 'Supprimer',
                  onPressed: () => _deleteClinicalData(data.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteClinicalData(int id) async {
    try {
      final authProvider = context.read<AuthProvider>();
      await ClinicalDataService(authProvider.token!).deleteClinicalData(id);
      _loadClinicalData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donnée clinique supprimée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la suppression: ${e.toString()}')),
      );
    }
  }
}