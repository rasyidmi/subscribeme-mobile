class Class {
  final String title;
  final int id;

  Class({
    required this.title,
    required this.id,
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
        id: json['ID'],
        title: json["Title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
