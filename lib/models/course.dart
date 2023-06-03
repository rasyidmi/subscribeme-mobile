class Course {
  final int id;
  final String name;
  bool isSubscribe;

  Course({
    required this.name,
    required this.id,
    this.isSubscribe = false,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'],
        name: json["name"],
        isSubscribe: json["is_subscribed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_subscribed": isSubscribe,
      };
}
