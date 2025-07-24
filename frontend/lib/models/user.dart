class User {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String insuranceNumber;
  final List<String> comorbidities;
  final double weight;
  final double height;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.insuranceNumber,
    required this.comorbidities,
    required this.weight,
    required this.height,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      insuranceNumber: json['insuranceNumber'],
      comorbidities: List<String>.from(json['comorbidities']),
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
    );
  }
}