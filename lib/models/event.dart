class Event implements Comparable {
  String id;
  String eventId;
  String name;
  DateTime deadlineTime;
  bool isDone;
  String type;
  String courseName;

  Event({
    required this.name,
    required this.id,
    required this.deadlineTime,
    required this.isDone,
    required this.type,
    required this.courseName,
    required this.eventId,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        eventId: json["event_id"],
        name: json["class_event"]["event_name"],
        isDone: json["is_done"],
        deadlineTime: DateTime.parse(json["class_event"]["date"].toString()),
        type: json["class_event"]["type"],
        courseName: json["class_event"]["course_scele"]["course_scele_name"],
      );

  int get remainingDays => deadlineTime.difference(DateTime.now()).inDays;

  bool get isToday => remainingDays == 0;

  @override
  int compareTo(other) {
    return deadlineTime.isAfter(other.deadlineTime) ? 1 : -1;
  }
}
