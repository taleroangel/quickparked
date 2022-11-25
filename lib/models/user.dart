import 'package:firebase_database/firebase_database.dart';
import 'package:quickparked/models/parking.dart';

class User {
  final String fullname;
  final String email;
  final bool active;
  final int? phone;
  final String? vehicle;
  final String createdAt;
  final String lastLogin;
  final List<String> favorites;

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
    this.favorites = const [],
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        "fullname": fullname,
        "email": email,
        "active": active,
        "phone": phone,
        "vehicle": vehicle,
        "createdAt": createdAt,
        "lastLogin": lastLogin,
        "favorites": favorites,
        "latitude": latitude,
        "longitude": longitude
      };

  User.fromMap(Map<String, dynamic> json)
      : fullname = json['fullname'] ?? "Usuario",
        email = json['email'],
        active = json['active'],
        phone = json['phone'],
        vehicle = json['vehicle'],
        createdAt = json['createdAt'],
        lastLogin = json['lastLogin'],
        latitude = json['latitude']?.toDouble() ?? 0,
        longitude = json['longitude']?.toDouble() ?? 0,
        favorites = json['favorites'] != null
            ? (json['favorites'] as List<Object?>)
                .map((e) => e.toString())
                .toList()
            : [];

  static Future<User> fetchUserFromFirebase(String uid) async {
    DatabaseEvent event = await FirebaseDatabase.instance
        .ref('users/$uid')
        .once(DatabaseEventType.value);

    return User.fromMap(Map<String, dynamic>.from(
        event.snapshot.value as Map<Object?, Object?>));
  }

  Future<void> updateUserOnFirebase(String uid) async {
    await FirebaseDatabase.instance.ref('/users/$uid').update(toMap());
  }

  List<Parking> favoriteParkings(List<Parking> parkings) =>
      parkings.where((element) => favorites.contains(element.uid)).toList();
}
