class User {
  final String id;
  final String name;
  final String email;
  final String roleId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      roleId: json['roleId'],
    );
  }
}