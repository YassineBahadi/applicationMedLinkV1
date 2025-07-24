import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/medical_test.dart';
import 'package:frontend/utils/constants.dart';

class MedicalTestService {
  final String token;

  MedicalTestService(this.token);

  Future<List<MedicalTest>> getMedicalTests() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/api/medical-tests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MedicalTest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load medical tests');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<MedicalTest>> getMedicalTestsByType(String type) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/api/medical-tests/$type'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MedicalTest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load medical tests by type');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<MedicalTest> addMedicalTest(MedicalTest medicalTest) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/api/medical-tests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(medicalTest.toJson()),
      );

      if (response.statusCode == 200) {
        return MedicalTest.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add medical test');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<MedicalTest> updateMedicalTest(MedicalTest medicalTest) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.apiUrl}/api/medical-tests/${medicalTest.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(medicalTest.toJson()),
      );

      if (response.statusCode == 200) {
        return MedicalTest.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update medical test');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<bool> deleteMedicalTest(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Constants.apiUrl}/api/medical-tests/$id'),
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