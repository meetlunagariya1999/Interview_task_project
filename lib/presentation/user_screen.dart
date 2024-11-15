// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:interviewtask/Api_Service/api_service.dart';
// import 'package:interviewtask/Bloc/fatch_user_bloc.dart';
// import 'package:interviewtask/Bloc/fatch_user_event.dart';
// import 'package:interviewtask/Bloc/fatch_user_state.dart';

// class UserListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           centerTitle: true,
//           title: Text('Users'),
//           bottom: TabBar(
//             dividerColor: Colors.grey,
//             labelColor: Colors.black,
//             unselectedLabelColor: Colors.black87,
//             indicatorColor: Colors.red,
//             tabs: [
//               Tab(text: 'All Users'),
//               Tab(text: 'Favorites'),
//             ],
//           ),
//         ),
//         body: BlocProvider(
//           create: (context) => UserBloc(ApiService())..add(FetchUsers()),
//           child: TabBarView(
//             children: [
//               UserListView(showFavorites: false),
//               UserListView(showFavorites: true),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class UserListView extends StatelessWidget {
//   final bool showFavorites;

//   UserListView({required this.showFavorites});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<UserBloc, UserState>(
//       builder: (context, state) {
//         if (state is UserLoading) {
//           return Center(child: CircularProgressIndicator());
//         } else if (state is UserLoaded) {
//           final usersToShow = showFavorites
//               ? state.users
//                   .where((user) => state.favoriteUserIds.contains(user.id))
//                   .toList()
//               : state.users;

//           if (usersToShow.isEmpty) {
//             return Center(
//                 child: Text(
//                     showFavorites ? 'No Favorites Yet' : 'No Users Found'));
//           }

//           return ListView.builder(
//             itemCount: usersToShow.length,
//             itemBuilder: (context, index) {
//               final user = usersToShow[index];
//               final isFavorite = state.favoriteUserIds.contains(user.id);

//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(user.avatar),
//                 ),
//                 title: Text('${user.firstName} ${user.lastName}'),
//                 trailing: IconButton(
//                   icon: Icon(
//                     isFavorite ? Icons.favorite : Icons.favorite_border,
//                     color: isFavorite ? Colors.red : null,
//                   ),
//                   onPressed: () {
//                     BlocProvider.of<UserBloc>(context)
//                         .add(ToggleFavorite(user));
//                   },
//                 ),
//               );
//             },
//           );
//         } else if (state is UserError) {
//           return Center(child: Text('Error loading users'));
//         }
//         return Container();
//       },
//     );
//   }
// }

// screens/user_list_screen.dart
// screens/user_list_screen.dart
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
