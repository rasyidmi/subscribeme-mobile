class StudentEventModel {
  int id;
  int eventId;
  String title;
  String courseTitle;
  String className;
  DateTime deadlineDate;

  StudentEventModel({
    required this.id,
    required this.eventId,
    required this.title,
    required this.courseTitle,
    required this.className,
    required this.deadlineDate,
  });

  factory StudentEventModel.fromJson(Map<String, dynamic> json) => StudentEventModel(
        id: json['ID'],
        eventId: json["EventID"],
        title: json["EventName"],
        courseTitle: json['SubjectName'],
        className: json["ClassName"],
        deadlineDate: DateTime.parse(json['DeadlineDate'].toString()),
      );
}
