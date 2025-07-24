import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUser(authProvider.token!);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.user == null) {
      return const Center(child: Text('Failed to load user data'));
    }

    final user = userProvider.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Informations personnelles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileItem('Nom d\'utilisateur', user.username),
            _buildProfileItem('Prénom', user.firstName),
            _buildProfileItem('Nom', user.lastName),
            _buildProfileItem(
                'Date de naissance', user.dateOfBirth.toString().split(' ')[0]),
            _buildProfileItem('Numéro d\'assurance', user.insuranceNumber),
            const SizedBox(height: 20),
            const Text(
              'Comorbidités:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (user.comorbidities.isEmpty)
              const Text('Aucune comorbidité enregistrée')
            else
              Column(
                children: user.comorbidities
                    .map((comorbidity) => ListTile(
                          leading: const Icon(Icons.medical_services),
                          title: Text(comorbidity),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 20),
            const Text(
              'Données cliniques:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildProfileItem('Poids', '${user.weight} kg'),
            _buildProfileItem('Taille', '${user.height} cm'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}