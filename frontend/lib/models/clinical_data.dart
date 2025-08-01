import 'package:intl/intl.dart';

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
    try {
      return ClinicalData(
        id: json['id'] as int,
        parameterType: json['parameterType'] as String,
        value: (json['value'] as num).toDouble(),
        recordedAt: DateTime.parse(json['recordedAt'] as String).toLocal(),
      );
    } catch (e) {
      throw FormatException('Failed to parse ClinicalData: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'parameterType': parameterType,
      'value': value,
      'recordedAt': recordedAt.toUtc().toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClinicalData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  String formattedDate([String pattern = 'dd/MM/yyyy HH:mm']) {
    return DateFormat(pattern).format(recordedAt);
  }
}