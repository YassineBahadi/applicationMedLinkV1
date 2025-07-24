import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/appointment.dart';
import 'package:frontend/utils/constants.dart';

class AppointmentService {
  final String token;

  AppointmentService(this.token);

  Future<List<Appointment>> getAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/api/appointments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Appointment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<Appointment>> getUpcomingAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/api/appointments/upcoming'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Appointment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load upcoming appointments');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<Appointment> addAppointment(Appointment appointment) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/api/appointments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(appointment.toJson()),
      );

      if (response.statusCode == 200) {
        return Appointment.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add appointment');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<Appointment> updateAppointment(Appointment appointment) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.apiUrl}/api/appointments/${appointment.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(appointment.toJson()),
      );

      if (response.statusCode == 200) {
        return Appointment.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update appointment');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<bool> deleteAppointment(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Constants.apiUrl}/api/appointments/$id'),
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