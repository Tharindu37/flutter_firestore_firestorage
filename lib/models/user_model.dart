class UserModel {
  final String name;
  final int age;
  final String profileImage;
  UserModel(this.name, this.age, this.profileImage);

  // Convert a UserModel into a Map.
  Map<String, dynamic> toMap() {
    return {'name': name, 'age': age, 'profileImage': profileImage};
  }

  // Convert a Map into a UserModel
  factory UserModel.formMap(Map<String, dynamic> map) {
    return UserModel(map['name'], map['age'], map['profileImage']);
  }
}
