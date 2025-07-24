import 'package:intl/intl.dart'; // Add this import

class Medication {
  final int id;
  final String name;
  final String dosage;
  final String form;
  final int timesPerDay;
  final List<DateTime> intakeTimes;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.form,
    required this.timesPerDay,
    required this.intakeTimes,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      form: json['form'],
      timesPerDay: json['timesPerDay'],
      intakeTimes: (json['intakeTimes'] as List)
          .map((timeStr) => _parseTimeString(timeStr)) // Use custom parser
          .toList(),
    );
  }

  // Custom time parser (handles "HH:mm:ss" format)
  static DateTime _parseTimeString(String timeStr) {
    try {
      // Parse as today's date + the given time
      final now = DateTime.now();
      final timeFormat = DateFormat('HH:mm:ss');
      final dateTime = timeFormat.parse(timeStr);
      
      return DateTime(
        now.year,
        now.month,
        now.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      );
    } catch (e) {
      // Fallback to current time if parsing fails
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'form': form,
      'timesPerDay': timesPerDay,
      'intakeTimes': intakeTimes.map((time) => 
        DateFormat('HH:mm:ss').format(time)).toList(), // Convert back to "HH:mm:ss"
    };
  }
}