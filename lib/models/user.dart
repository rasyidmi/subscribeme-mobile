import 'package:subscribeme_mobile/commons/constants/role.dart';

class User {
  User({
    required this.npm,
    required this.name,
    required this.username,
    required this.role,
    this.isExist,
  });

  String npm;
  String name;
  String username;
  Role role;
  bool? isExist;

  factory User.fromJson(Map<String, dynamic> json) => User(
        npm: json["npm"],
        name: json["nama"],
        username: json["username"],
        role: json["role"] == 'Dosen' ? Role.lecturer : Role.student,
        isExist: json["is_user_exist"],
      );

  Map<String, dynamic> toJson() => {
        "npm": name,
        "name": name,
        "username": username,
        "role": role == Role.lecturer ? 'Dosen' : 'Mahasiswa',
      };
}
