import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/medication.dart';
import 'package:frontend/utils/constants.dart';

class MedicationService {
  final String token;

  MedicationService(this.token);

  // Future<List<Medication>> getMedications() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('${Constants.apiUrl}/api/medications'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       return data.map((json) => Medication.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load medications');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to connect to the server');
  //   }
  // }
  Future<List<Medication>> getMedications() async {
  try {
    print('Attempting to call: ${Constants.apiUrl}/api/medications'); // Add this
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/api/medications'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}'); // Add this
    print('Response body: ${response.body}'); // Add this

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Medication.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load medications: ${response.statusCode}');
    }
  } catch (e) {
    print('Error details: $e'); // Add this
    throw Exception('Failed to connect to the server: $e');
  }
}

  Future<Medication> addMedication(Medication medication) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/api/medications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(medication.toJson()),
      );

      if (response.statusCode == 200) {
        return Medication.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add medication');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<Medication> updateMedication(Medication medication) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.apiUrl}/api/medications/${medication.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(medication.toJson()),
      );

      if (response.statusCode == 200) {
        return Medication.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update medication');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<bool> deleteMedication(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Constants.apiUrl}/api/medications/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}