class Attendance {
  final bool isAttend;
  final String date;
  final String time;

  Attendance({
    required this.isAttend,
    required this.date,
    required this.time,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        isAttend: json["true"],
        date: json["date"],
        time: json["time"],
      );
}
