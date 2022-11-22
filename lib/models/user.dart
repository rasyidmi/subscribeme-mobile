import 'package:subscribeme_mobile/commons/constants/role.dart';

class User {
  User({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
  });

  String? id;
  String name;
  String email;
  Role role;
  String? avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['ID'],
      name: json["Name"],
      email: json["Email"],
      role: json["Role"] == 'admin' ? Role.admin : Role.user,
      avatar: json["Avatar"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role == Role.admin ? 'admin' : 'user',
        "avatar": avatar,
      };
}
