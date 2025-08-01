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
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      reminderSet: json['reminderSet'] as bool,
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

  Appointment copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? appointmentDate,
    bool? reminderSet,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      reminderSet: reminderSet ?? this.reminderSet,
    );
  }

  @override
  String toString() => 'Appointment($title, $appointmentDate)';
}