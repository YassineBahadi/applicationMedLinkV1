import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:frontend/screens/medical_tests/add_medical_test_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/medical_test.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/medical_test_service.dart';
import 'package:frontend/widgets/error_widget.dart';
import 'package:frontend/widgets/loading_widget.dart';

class MedicalTestsScreen extends StatefulWidget {
  const MedicalTestsScreen({Key? key}) : super(key: key);

  @override
  _MedicalTestsScreenState createState() => _MedicalTestsScreenState();
}

class _MedicalTestsScreenState extends State<MedicalTestsScreen> {
  late Future<List<MedicalTest>> _medicalTestsFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadMedicalTests();
  }

  Future<void> _loadMedicalTests() async {
    setState(() {
      final authProvider = context.read<AuthProvider>();
      _medicalTestsFuture = MedicalTestService(
        authProvider.token!,
      ).getMedicalTests();
    });
  }

  Future<void> _navigateToAddScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditMedicalTestScreen()),
    );

    if (result == true) {
      _refreshIndicatorKey.currentState?.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Tests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddScreen(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _loadMedicalTests,
        child: FutureBuilder<List<MedicalTest>>(
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
              return const ErrorWidget(message: 'No medical tests found');
            }

            return _buildMedicalTestList(snapshot.data!);
          },
        ),
      ),
    );
  }

  Widget _buildMedicalTestList(List<MedicalTest> medicalTests) {
    return ListView.builder(
      itemCount: medicalTests.length,
      itemBuilder: (context, index) {
        final test = medicalTests[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(test.testName),
            subtitle: Text('${test.testType} - ${test.formattedDate()}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                  tooltip: 'Modifier',
                  onPressed: () => _navigateToEditScreen(context, test),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  tooltip: 'Supprimer',
                  onPressed: () => _deleteMedicalTest(test.id),
                ),
              ],
            ),
            onTap: () => _navigateToEditScreen(context, test),
          ),
        );
      },
    );
  }

  Future<void> _navigateToEditScreen(
    BuildContext context,
    MedicalTest test,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMedicalTestScreen(medicalTest: test),
      ),
    );

    if (result == true) {
      _loadMedicalTests();
    }
  }

  Future<void> _deleteMedicalTest(int id) async {
    try {
      final authProvider = context.read<AuthProvider>();
      await MedicalTestService(authProvider.token!).deleteMedicalTest(id);
      _loadMedicalTests();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Medical test deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: ${e.toString()}')),
      );
    }
  }
}
