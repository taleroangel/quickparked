class User {
  final String fullname;
  final String email;
  final bool active;
  final int? phone;
  final List<dynamic> vehicles;
  final String createdAt;
  final String lastLogin;

  const User({
    required this.fullname,
    required this.email,
    this.active = false,
    this.phone,
    this.vehicles = const <dynamic>[],
    required this.createdAt,
    required this.lastLogin,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        "fullname": fullname,
        "email": email,
        "active": active,
        "phone": phone,
        "vehicles": vehicles,
        "createdAt": createdAt,
        "lastLogin": lastLogin
      };

  User.fromJson(Map<String, dynamic> json)
      : fullname = json['fullname'] ?? "Usuario",
        email = json['email'],
        active = json['active'],
        phone = json['phone'],
        vehicles = json['vehicles'] ?? [],
        createdAt = json['createdAt'],
        lastLogin = json['lastLogin'];
}
