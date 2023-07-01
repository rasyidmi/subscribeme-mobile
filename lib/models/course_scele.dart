class CourseScele {
  final String id;
  final int sceleId;
  final String name;

  CourseScele({required this.id, required this.sceleId, required this.name});

  factory CourseScele.fromJson(Map<String, dynamic> json) => CourseScele(
      id: json["id"],
      sceleId: json["course_scele_id"],
      name: json["course_scele_name"]);
}
