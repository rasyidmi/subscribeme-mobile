import 'package:subscribeme_mobile/models/class_schedule.dart';

class Class {
  final String classCode;
  final String name;
  final String courseCode;
  final String courseName;
  final List<dynamic> lectureName;
  final int credit;
  final List<ClassSchedule> schedule;

  Class({
    required this.classCode,
    required this.name,
    required this.courseCode,
    required this.courseName,
    required this.lectureName,
    required this.credit,
    required this.schedule,
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
        classCode: json["class_code"],
        name: json["class_name"],
        courseCode: json["course"]["course_code"],
        courseName: json["course"]["course_name"],
        lectureName: json["lectures"],
        credit: json["course"]["total_sks"],
        schedule: Class.convertSchedule(json["class_schedule"]),
      );

  Map<String, dynamic> toJson() => {
        "class_code": classCode,
        "name": name,
        "course_code": courseCode,
        "lecture_name": lectureName,
        "credit": credit
      };

  static List<ClassSchedule> convertSchedule(List<dynamic> json) {
    List<ClassSchedule> schedule = [];
    for (var i = 0; i < json.length; i++) {
      schedule.add(ClassSchedule.fromJson(json[i]));
    }
    return schedule;
  }
}
