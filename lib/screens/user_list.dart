import 'package:flutter/material.dart';
import 'package:flutter_firestore_crud/models/user_model.dart';
import 'package:flutter_firestore_crud/services/file.dart';
import 'package:flutter_firestore_crud/services/user.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final UserServices userServices = UserServices();
  final FileService fileService = FileService();

  _deleteUser(String id, String downloadUrl) async {
    print("Delete User: $id");
    try {
      await userServices.deleteUser(id);
      await fileService.deleteFileByDownloadUrl(downloadUrl);
      setState(() {});
      print("Deleted!");
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: FutureBuilder<List<UserModel>>(
            future: userServices.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users found.'));
              } else {
                List<UserModel> users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    UserModel user = users[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user.profileImage.isNotEmpty
                            ? NetworkImage(user.profileImage)
                            : AssetImage("assets/default_profile.png")
                                as ImageProvider,
                        radius: 30,
                      ),
                      title: Text(user.name),
                      subtitle: Text('Age: ${user.age}'),
                      onLongPress: () => {
                        _showDeleteConfirmationDialog(
                            user.id!, user.profileImage!)
                      },
                    );
                  },
                );
              }
            }),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      String id, String downloadUrl) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete User"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text("Are you sure you want to delete this user?")],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    _deleteUser(id, downloadUrl);
                    Navigator.of(context).pop();
                  },
                  child: Text("Delete"))
            ],
          );
        });
  }
}
