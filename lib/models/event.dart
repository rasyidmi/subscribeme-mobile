class Event implements Comparable {
  String id;
  String name;
  DateTime deadlineTime;
  bool isDone;

  Event({
    required this.name,
    required this.id,
    required this.deadlineTime,
    required this.isDone,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['event_id'],
        name: json["class_event"]["event_name"],
        isDone: json["is_done"],
        deadlineTime: DateTime.parse(json["class_event"]["date"].toString()),
      );

  int get remainingDays => deadlineTime.difference(DateTime.now()).inDays;

  bool get isToday => remainingDays == 0;

  @override
  int compareTo(other) {
    return deadlineTime.isAfter(other.deadlineTime) ? 1 : -1;
  }
}
