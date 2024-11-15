// class User {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String avatar;

//   User(
//       {required this.id,
//       required this.firstName,
//       required this.lastName,
//       required this.avatar});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       firstName: json['first_name'],
//       lastName: json['last_name'],
//       avatar: json['avatar'],
//     );
//   }
// }
// models/user_model.dart
// models/user_model.dart
class UserModel {
  final int id;
  final String name;
  final String email;
  final String username;
  final String phone;
  final String website;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.phone,
    required this.website,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}
