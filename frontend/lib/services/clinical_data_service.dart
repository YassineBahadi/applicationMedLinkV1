import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/clinical_data.dart';
import 'package:frontend/utils/constants.dart';

class ClinicalDataService {
  final String token;

  ClinicalDataService(this.token);

  Future<List<ClinicalData>> getClinicalData() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/api/clinical-data'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ClinicalData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load clinical data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<ClinicalData>> getClinicalDataByType(String type) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/api/clinical-data/$type'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ClinicalData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load clinical data by type');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<ClinicalData> addClinicalData(ClinicalData clinicalData) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/api/clinical-data'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(clinicalData.toJson()),
      );

      if (response.statusCode == 200) {
        return ClinicalData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add clinical data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<ClinicalData> updateClinicalData(ClinicalData clinicalData) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.apiUrl}/api/clinical-data/${clinicalData.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(clinicalData.toJson()),
      );

      if (response.statusCode == 200) {
        return ClinicalData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update clinical data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<bool> deleteClinicalData(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Constants.apiUrl}/api/clinical-data/$id'),
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