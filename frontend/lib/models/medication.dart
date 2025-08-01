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
    try {
      return Medication(
        id: _parseInt(json['id']),
        name: json['name'] as String,
        dosage: json['dosage'] as String,
        form: json['form'] as String,
        timesPerDay: _parseInt(json['timesPerDay']),
        intakeTimes: _parseIntakeTimes(json['intakeTimes']),
      );
    } catch (e) {
      throw FormatException('Failed to parse Medication: $e');
    }
  }

  static List<DateTime> _parseIntakeTimes(List<dynamic> timeStrings) {
    return timeStrings.map((timeStr) {
      try {
        return _parseTimeString(timeStr as String);
      } catch (e) {
        throw FormatException('Failed to parse intake time: $timeStr');
      }
    }).toList();
  }

  static DateTime _parseTimeString(String timeStr) {
    final components = timeStr.split(':');
    if (components.length < 2) {
      throw FormatException('Invalid time format: $timeStr');
    }

    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(components[0]),  // hour
      int.parse(components[1]),  // minute
      components.length > 2 ? int.parse(components[2]) : 0, // seconds
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw FormatException('Invalid integer value: $value');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'form': form,
      'timesPerDay': timesPerDay,
      'intakeTimes': intakeTimes.map((time) => 
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}'
      ).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Medication &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          dosage == other.dosage &&
          form == other.form &&
          timesPerDay == other.timesPerDay &&
          intakeTimes.length == other.intakeTimes.length &&
          intakeTimes.every((t) => other.intakeTimes.contains(t));

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      dosage.hashCode ^
      form.hashCode ^
      timesPerDay.hashCode ^
      intakeTimes.fold(0, (hash, time) => hash ^ time.hashCode);
}