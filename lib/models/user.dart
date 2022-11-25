import 'package:subscribeme_mobile/commons/constants/role.dart';

class User {
  User({
    required this.id,
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
      id: json['id'],
      name: json["name"],
      email: json["email"],
      role: json["role"] == 'admin' ? Role.admin : Role.user,
      avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role == Role.admin ? 'admin' : 'user',
        "avatar": avatar,
      };
}
