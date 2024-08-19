class UserModel {
  String? id;
  final String name;
  final int age;
  final String profileImage;

  UserModel(this.name, this.age, this.profileImage);

  UserModel.withId(this.id, this.name, this.age, this.profileImage);

  // Convert a UserModel into a Map.
  Map<String, dynamic> toMap() {
    return {'name': name, 'age': age, 'profileImage': profileImage};
  }

  // Convert a Map into a UserModel
  factory UserModel.formMap(Map<String, dynamic> map, String id) {
    return UserModel.withId(id, map['name'], map['age'], map['profileImage']);
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'UserMode(id:$id, name: $name, age: $age, profileImage: $profileImage)';
  }
}
