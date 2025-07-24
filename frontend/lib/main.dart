// ... (autres imports)
import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/HomeScreen.dart';
import 'package:frontend/screens/appointments/appointments_screen.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/register_screen.dart';
import 'package:frontend/screens/clinical_data/clinical_data_screen.dart';
import 'package:frontend/screens/dashboard/dashboard_screen.dart';
import 'package:frontend/screens/medical_tests/medical_tests_screen.dart';
import 'package:frontend/screens/medications/medications_screen.dart';
import 'package:frontend/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'MEDLINK',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/medications': (context) => const MedicationsScreen(),
          '/clinical-data': (context) => const ClinicalDataScreen(),
          '/medical-tests': (context) => const MedicalTestsScreen(),
          '/appointments': (context) => const AppointmentsScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}