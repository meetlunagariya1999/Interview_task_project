// import 'package:interviewtask/Model/user_model.dart';

// abstract class UserEvent {}

// class FetchUsers extends UserEvent {}

// class ToggleFavorite extends UserEvent {
//   final User user;
//   ToggleFavorite(this.user);
// }
// bloc/user_event.dart
// bloc/user_event.dart
abstract class UserEvent {}

class LoadUsers extends UserEvent {}

class RefreshUsers extends UserEvent {}

class SearchUsers extends UserEvent {
  final String query;

  SearchUsers(this.query);
}
