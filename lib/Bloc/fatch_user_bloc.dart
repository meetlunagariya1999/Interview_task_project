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
