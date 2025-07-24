import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'MEDLINK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.medication),
            title: const Text('Médicaments'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/medications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.monitor_heart),
            title: const Text('Surveillance'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/clinical-data');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Bilans'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/medical-tests');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Rendez-vous'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/appointments');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}