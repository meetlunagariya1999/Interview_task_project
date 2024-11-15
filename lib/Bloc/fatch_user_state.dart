// import 'package:interviewtask/Model/user_model.dart';

// abstract class UserState {}

// class UserLoading extends UserState {}

// class UserLoaded extends UserState {
//   final List<User> users;
//   final List<int> favoriteUserIds;

//   UserLoaded(this.users, this.favoriteUserIds);
// }

// class UserError extends UserState {}
// bloc/user_state.dart

import 'package:interviewtask/Model/user_model.dart';

abstract class UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;

  UserLoaded(this.users);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
