class Event implements Comparable {
  int id;
  String title;
  DateTime deadlineTime;
  String courseTitle;

  Event({
    required this.title,
    required this.id,
    required this.deadlineTime,
    required this.courseTitle,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['ID'],
        title: json["Title"],
        courseTitle: json['SubjectName'],
        deadlineTime: DateTime.parse(json['DeadlineDate'].toString()),
      );

  int get remainingDays => deadlineTime.difference(DateTime.now()).inDays;

  bool get isToday => remainingDays == 0;

  @override
  int compareTo(other) {
    return deadlineTime.isAfter(other.deadlineTime) ? 1 : -1;
  }
}
