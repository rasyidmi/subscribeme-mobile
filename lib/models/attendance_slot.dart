class AttendanceSlot {
  final String id;
  final bool isGeofence;
  final bool? isOpen;
  final int? duration;
  final DateTime? openedTime;
  final int? totalStudent;
  final int? totalPresent;
  final int? totalNotPresent;

  AttendanceSlot({
    required this.id,
    required this.isGeofence,
    this.isOpen,
    this.duration,
    this.openedTime,
    this.totalStudent,
    this.totalPresent,
    this.totalNotPresent,
  });

  factory AttendanceSlot.fromJson(Map<String, dynamic> json) => AttendanceSlot(
        id: json["id"],
        isGeofence: json["is_geofence"],
        isOpen: json["end_time"] != null && json["start_time"] != null
            ? _isOpen(json["end_time"], json["start_time"])
            : null,
        duration: json["end_time"] != null && json["start_time"] != null
            ? _getDuration(json["end_time"], json["start_time"])
            : null,
        openedTime: json["start_time"] != null
            ? DateTime.parse(json["start_time"])
            : null,
        totalStudent: json["total_student_class"],
        totalPresent: json["total_present_student_class"],
        totalNotPresent: json["total_absence_student"],
      );

  static bool _isOpen(String endTime, String startTime) {
    final endTimeConverted = DateTime.parse(endTime);
    final startTimeConverted = DateTime.parse(startTime);
    final currentTime = DateTime.now();
    if (currentTime.isAfter(startTimeConverted) &&
        currentTime.isBefore(endTimeConverted)) {
      return true;
    }
    return false;
  }

  static int _getDuration(String endTime, String startTime) {
    final endTimeConverted = DateTime.parse(endTime);
    final startTimeConverted = DateTime.parse(startTime);
    return endTimeConverted.difference(startTimeConverted).inMinutes;
  }
}
