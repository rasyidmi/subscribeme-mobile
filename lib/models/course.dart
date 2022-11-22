class Course {
  final int id;
  final String title;
  final String major;
  final int term;

  Course({
    required this.title,
    required this.id,
    required this.major,
    required this.term,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['ID'],
        title: json["Title"],
        major: json['Major'],
        term: json['Term']
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "major": major,
        "term": term,
      };
}
