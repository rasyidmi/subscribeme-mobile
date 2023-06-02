class Attendance {
  final String id;
  final bool isAttend;
  final String openedTime;
  final DateTime? recordTime;

  Attendance({
    required this.id,
    required this.isAttend,
    required this.openedTime,
    required this.recordTime,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json["class_absence_session_id"],
        isAttend: json["present"],
        openedTime: json["class_absence_open_time"],
        recordTime:
            json["present"] ? DateTime.parse(json["present_time"]) : null,
      );
}
