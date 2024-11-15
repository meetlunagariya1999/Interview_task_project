import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interviewtask/Api_Service/api_service.dart';
import 'package:interviewtask/Bloc/fatch_user_bloc.dart';
import 'package:interviewtask/Bloc/fatch_user_event.dart';
import 'package:interviewtask/Bloc/fatch_user_state.dart';

import 'user_detail_screen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(ApiService())..add(LoadUsers()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('User List'),
        ),
        body: UserListBody(),
      ),
    );
  }
}

class UserListBody extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  UserListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search by name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              context.read<UserBloc>().add(SearchUsers(query));
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<UserBloc>().add(RefreshUsers());
                  },
                  child: ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return Card(
                        child: ListTile(
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserDetailScreen(user: user),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              } else if (state is UserError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      ElevatedButton(
                        onPressed: () {
                          context.read<UserBloc>().add(LoadUsers());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No users found.'));
              }
            },
          ),
        ),
      ],
    );
  }
}
