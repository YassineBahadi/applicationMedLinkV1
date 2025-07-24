import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/user.dart';
import 'package:frontend/utils/constants.dart';

class AuthService {
  Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['accessToken'];
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<bool> register(
      String username,
      String password,
      String firstName,
      String lastName,
      DateTime dateOfBirth,
      String insuranceNumber,
      List<String> comorbidities,
      double weight,
      double height) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'dateOfBirth': dateOfBirth.toIso8601String(),
          'insuranceNumber': insuranceNumber,
          'comorbidities': comorbidities,
          'weight': weight,
          'height': height,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<User> getCurrentUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/api/patient/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}