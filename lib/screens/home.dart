import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_crud/models/user_model.dart';
import 'package:flutter_firestore_crud/screens/user_list.dart';
import 'package:flutter_firestore_crud/services/file.dart';
import 'package:flutter_firestore_crud/services/storage_service.dart';
import 'package:flutter_firestore_crud/services/user.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // User Details
  String name = "";
  String profileImage = "";
  File? _image;
  int age = 0;
  PlatformFile? pickedFile;

  final ImagePicker _picker = ImagePicker();
  final UserServices _userService = UserServices();
  final StorageService _storageService = StorageService();
  final FileService _fileService = FileService();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        profileImage = pickedFile.path;
        // await uploadFile(_image!);
      });
    }
  }

  Future<void> _createUser() async {
    print("Create User...");
    print(_image);
    print(name);
    print(age);
    DateTime now = DateTime.now();
    final downloadUrl = await _fileService.uploadFile(_image!, "user/$now");
    UserModel user = new UserModel(name, age, downloadUrl);
    dynamic result = await _userService.createUser(user);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserList()));
                },
                icon: const Icon(Icons.people_alt))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  "Create User",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                    child: Column(
                  children: [
                    // Profile Image
                    GestureDetector(
                      // onTap: _pickImage,
                      onTap: _pickImage,
                      child: CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? const Icon(
                                  Icons.person,
                                  size: 80,
                                )
                              : null),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Name
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: InputDecoration(hintText: "Enter Your Name"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Age
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          age = int.tryParse(value)!;
                        });
                      },
                      decoration: InputDecoration(hintText: "Enter Your Age"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: _createUser, child: Text("Create User"))
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
