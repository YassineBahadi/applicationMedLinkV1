class Appointment {
  final int id;
  final String title;
  final String description;
  final DateTime appointmentDate;
  final bool reminderSet;

  Appointment({
    required this.id,
    required this.title,
    required this.description,
    required this.appointmentDate,
    required this.reminderSet,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      reminderSet: json['reminderSet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'appointmentDate': appointmentDate.toIso8601String(),
      'reminderSet': reminderSet,
    };
  }
}