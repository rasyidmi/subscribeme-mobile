import 'package:subscribeme_mobile/models/event.dart';

class Class {
  final String title;
  final int id;
  final bool? isSubscribe;
  List<Event>? listEvent;

  Class({
    required this.title,
    required this.id,
    this.isSubscribe,
    this.listEvent,
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
        id: json['ID'],
        title: json["Title"],
        isSubscribe: json["IsSubscribe"] ,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
