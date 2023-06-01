class ClassSchedule {
  final String day;
  final String startTime;
  final String endTime;

  ClassSchedule({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory ClassSchedule.fromJson(Map<String, dynamic> json) => ClassSchedule(
        day: json["day"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );
}
