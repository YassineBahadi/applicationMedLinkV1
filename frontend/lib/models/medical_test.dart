import 'package:intl/intl.dart';

class MedicalTest {
  final int id;
  final String testType;
  final String testName;
  final String result;
  final String? filePath;
  final DateTime testDate;

  MedicalTest({
    required this.id,
    required this.testType,
    required this.testName,
    required this.result,
    this.filePath,
    required this.testDate,
  });

  factory MedicalTest.fromJson(Map<String, dynamic> json) {
    try {
      return MedicalTest(
        id: json['id'] as int,
        testType: json['testType'] as String,
        testName: json['testName'] as String,
        result: json['result'] as String,
        filePath: json['filePath'] as String?,
        testDate: DateTime.parse(json['testDate'] as String).toLocal(),
      );
    } catch (e) {
      throw FormatException('Failed to parse MedicalTest: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'testType': testType,
      'testName': testName,
      'result': result,
      if (filePath != null) 'filePath': filePath,
      'testDate': testDate.toUtc().toIso8601String(),
    };
  }

  String formattedDate([String pattern = 'dd/MM/yyyy']) {
    return DateFormat(pattern).format(testDate);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalTest &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}