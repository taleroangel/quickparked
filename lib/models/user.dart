import 'package:firebase_database/firebase_database.dart';

class User {
  final String fullname;
  final String email;
  final bool active;
  final int? phone;
  final String? vehicle;
  final String createdAt;
  final String lastLogin;

  final double latitude;
  final double longitude;

  const User({
    required this.fullname,
    required this.email,
    this.active = false,
    this.phone,
    this.vehicle,
    required this.createdAt,
    required this.lastLogin,
    this.latitude = 0,
    this.longitude = 0,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        "fullname": fullname,
        "email": email,
        "active": active,
        "phone": phone,
        "vehicle": vehicle,
        "createdAt": createdAt,
        "lastLogin": lastLogin
      };

  User.fromJson(Map<String, dynamic> json)
      : fullname = json['fullname'] ?? "Usuario",
        email = json['email'],
        active = json['active'],
        phone = json['phone'],
        vehicle = json['vehicle'],
        createdAt = json['createdAt'],
        lastLogin = json['lastLogin'],
        latitude = json['latitude'].toDouble() ?? 0,
        longitude = json['longitude'].toDouble() ?? 0;

  static Future<User> fetchUserFromFirebase(String uid) async {
    DatabaseEvent event = await FirebaseDatabase.instance
        .ref('users/$uid')
        .once(DatabaseEventType.value);

    return User.fromJson(Map<String, dynamic>.from(
        event.snapshot.value as Map<Object?, Object?>));
  }

  Future<void> updateUserOnFirebase(String uid) async {
    await FirebaseDatabase.instance.ref('/users/$uid').update(toJson());
  }
}
