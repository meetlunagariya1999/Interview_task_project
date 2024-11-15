// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:interviewtask/Model/user_model.dart';

// class ApiService {
//   Future<List<User>> fetchUsers() async {
//     final response =
//         await http.get(Uri.parse('https://reqres.in/api/users?page=2'));

//     if (response.statusCode == 200) {
//       final List data = jsonDecode(response.body)['data'];
//       return data.map((user) => User.fromJson(user)).toList();
//     } else {
//       throw Exception('Failed to load users');
//     }
//   }
// }
// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:interviewtask/Model/user_model.dart';

class ApiService {
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/users';

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
