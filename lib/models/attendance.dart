class Attendance {
  final String id;
  final String studentName;
  final String deviceCode;
  final bool isAttend;
  final String npm;
  final DateTime openedTime;
  final DateTime? recordTime;

  Attendance({
    required this.id,
    required this.studentName,
    required this.deviceCode,
    required this.isAttend,
    required this.npm,
    required this.openedTime,
    required this.recordTime,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json["class_absence_session_id"],
        studentName: json["student_name"],
        deviceCode: json["device_code"],
        isAttend: json["present"],
        npm: json["student_npm"],
        openedTime: DateTime.parse(json["class_absence_open_time"]),
        recordTime:
            json["present"] ? DateTime.parse(json["present_time"]) : null,
      );
}
