class ClinicalData {
  final int id;
  final String parameterType;
  final double value;
  final DateTime recordedAt;

  ClinicalData({
    required this.id,
    required this.parameterType,
    required this.value,
    required this.recordedAt,
  });

  factory ClinicalData.fromJson(Map<String, dynamic> json) {
    return ClinicalData(
      id: json['id'],
      parameterType: json['parameterType'],
      value: json['value']?.toDouble(),
      recordedAt: DateTime.parse(json['recordedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parameterType': parameterType,
      'value': value,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }
}