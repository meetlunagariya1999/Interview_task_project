// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:interviewtask/Api_Service/api_service.dart';
// import 'package:interviewtask/Bloc/fatch_user_event.dart';
// import 'package:interviewtask/Bloc/fatch_user_state.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//   final ApiService apiService;

//   UserBloc(this.apiService) : super(UserLoading()) {
//     // Register the event handlers
//     on<FetchUsers>(_onFetchUsers);
//     on<ToggleFavorite>(_onToggleFavorite);
//   }

//   Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
//     emit(UserLoading());
//     try {
//       final users = await apiService.fetchUsers();
//       final favoriteIds = await _loadFavorites();
//       emit(UserLoaded(users, favoriteIds));
//     } catch (_) {}
//   }

//   Future<void> _onToggleFavorite(
//       ToggleFavorite event, Emitter<UserState> emit) async {
//     if (state is UserLoaded) {
//       final currentState = state as UserLoaded;
//       final updatedFavorites = List<int>.from(currentState.favoriteUserIds);

//       if (updatedFavorites.contains(event.user.id)) {
//         updatedFavorites.remove(event.user.id);
//       } else {
//         updatedFavorites.add(event.user.id);
//       }

//       await _saveFavorites(updatedFavorites);
//       emit(UserLoaded(currentState.users, updatedFavorites));
//     }
//   }

//   Future<List<int>> _loadFavorites() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList('favorite_ids')?.map(int.parse).toList() ?? [];
//   }

//   Future<void> _saveFavorites(List<int> favoriteIds) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setStringList(
//         'favorite_ids', favoriteIds.map((id) => id.toString()).toList());
//   }
// }
// bloc/user_bloc.dart
// bloc/user_bloc.dart
// bloc/user_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interviewtask/Api_Service/api_service.dart';
import 'package:interviewtask/Bloc/fatch_user_event.dart';
import 'package:interviewtask/Bloc/fatch_user_state.dart';
import 'package:interviewtask/Model/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService apiService;
  List<UserModel> _allUsers = [];

  UserBloc(this.apiService) : super(UserLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<RefreshUsers>(_onLoadUsers);
    on<SearchUsers>(_onSearchUsers);
  }

  Future<void> _onLoadUsers(UserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      _allUsers = await apiService.fetchUsers();
      emit(UserLoaded(_allUsers));
    } catch (e) {
      emit(UserError('Failed to load users'));
    }
  }

  void _onSearchUsers(SearchUsers event, Emitter<UserState> emit) {
    final filteredUsers = _allUsers.where((user) {
      return user.name.toLowerCase().contains(event.query.toLowerCase());
    }).toList();
    emit(UserLoaded(filteredUsers));
  }
}
