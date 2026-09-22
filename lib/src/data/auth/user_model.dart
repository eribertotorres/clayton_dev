final class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String accessToken;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.accessToken,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      username: map['username'] as String,
      accessToken: map['accessToken'] as String,
    );
  }

  String get fullName => '$firstName $lastName';
}
