import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore_crud/models/user_model.dart';

class UserServices {
  // firestore reference
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  // create user
  Future createUser(UserModel user) async {
    return await users.add(user.toMap());
  }

  // Future<void> addUser(String name, String email, int age) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');

  //   return users
  //       .add({
  //         'name': name,
  //         'email': email,
  //         'age': age,
  //       })
  //       .then((value) => print("User added successfully!"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

  Future<List<UserModel>> getUsers() async {
    QuerySnapshot snapshot = await users.get();
    return snapshot.docs
        .map((doc) => UserModel.formMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Future<void> fetchUsers() {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');

  //   return users.get().then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((doc) {
  //       print('${doc.id} => ${doc.data()}');
  //     });
  //   }).catchError((error) => print("Failed to fetch users: $error"));
  // }

  // Future<void> updateUserEmail(String userId, String newEmail) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');

  //   return users
  //       .doc(userId)
  //       .update({'email': newEmail})
  //       .then((value) => print("User email updated successfully!"))
  //       .catchError((error) => print("Failed to update user email: $error"));
  // }

  // Future<void> deleteUser(String userId) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');

  //   return users
  //       .doc(userId)
  //       .delete()
  //       .then((value) => print("User deleted successfully!"))
  //       .catchError((error) => print("Failed to delete user: $error"));
  // }

  // Real-time Data Sync
  // Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  // usersStream.listen((QuerySnapshot snapshot) {
  //   snapshot.docs.forEach((doc) {
  //     print('${doc.id} => ${doc.data()}');
  //   });
  // });

  // Querying Data
  // Future<void> fetchUsersAboveAge(int minAge) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');

  //   return users
  //       .where('age', isGreaterThan: minAge)
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((doc) {
  //       print('${doc.id} => ${doc.data()}');
  //     });
  //   }).catchError((error) => print("Failed to fetch users: $error"));
  // }

  // Transactions
  // Future<void> incrementAge(String userId) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');

  //   return FirebaseFirestore.instance
  //       .runTransaction((transaction) async {
  //         DocumentSnapshot snapshot = await transaction.get(users.doc(userId));
  //         if (!snapshot.exists) {
  //           throw Exception("User not found!");
  //         }

  //         int currentAge = snapshot.data()['age'];
  //         transaction.update(users.doc(userId), {'age': currentAge + 1});
  //       })
  //       .then((value) => print("Age incremented successfully!"))
  //       .catchError((error) => print("Failed to increment age: $error"));
  // }
}
