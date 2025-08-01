import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/medical_test.dart';
import 'package:frontend/utils/constants.dart';

class MedicalTestService {
  static const Duration _timeoutDuration = Duration(seconds: 30);
  final String token;
  final http.Client _client;

  MedicalTestService(this.token, [http.Client? client]) 
      : _client = client ?? http.Client();

  Future<List<MedicalTest>> getMedicalTests() async {
    return _handleRequest<List<MedicalTest>>(
      Uri.parse('${Constants.apiUrl}/api/medical-tests'),
      parse: (data) => (data as List)
          .map((json) => MedicalTest.fromJson(json))
          .toList(),
    );
  }

  Future<MedicalTest> addMedicalTest(MedicalTest medicalTest) async {
    return _handleRequest<MedicalTest>(
      Uri.parse('${Constants.apiUrl}/api/medical-tests'),
      method: 'POST',
      body: medicalTest.toJson(),
      parse: (data) => MedicalTest.fromJson(data),
    );
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

  Future<T> _handleRequest<T>(
    Uri uri, {
    String method = 'GET',
    Map<String, dynamic>? body,
    required T Function(dynamic) parse,
  }) async {
    try {
      final response = await _makeRequest(uri, method, body);
      return _handleResponse(response, parse);
    } catch (e) {
      throw Exception('Failed to perform request: ${e.toString()}');
    }
  }

  Future<http.Response> _makeRequest(
    Uri uri, 
    String method, 
    Map<String, dynamic>? body
  ) async {
    final headers = _buildHeaders();
    
    switch (method.toUpperCase()) {
      case 'POST':
        return await _client.post(uri, headers: headers, body: json.encode(body))
            .timeout(_timeoutDuration);
      case 'PUT':
        return await _client.put(uri, headers: headers, body: json.encode(body))
            .timeout(_timeoutDuration);
      default:
        return await _client.get(uri, headers: headers)
            .timeout(_timeoutDuration);
    }
  }

  T _handleResponse<T>(http.Response response, T Function(dynamic) parse) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return parse(json.decode(response.body));
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  void dispose() {
    _client.close();
  }
}