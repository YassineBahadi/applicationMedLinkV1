class MedicalTest {
  final int id;
  final String testType;
  final String testName;
  final String result;
  final String filePath;
  final DateTime testDate;

  MedicalTest({
    required this.id,
    required this.testType,
    required this.testName,
    required this.result,
    required this.filePath,
    required this.testDate,
  });

  factory MedicalTest.fromJson(Map<String, dynamic> json) {
    return MedicalTest(
      id: json['id'],
      testType: json['testType'],
      testName: json['testName'],
      result: json['result'],
      filePath: json['filePath'],
      testDate: DateTime.parse(json['testDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testType': testType,
      'testName': testName,
      'result': result,
      'filePath': filePath,
      'testDate': testDate.toIso8601String(),
    };
  }
}