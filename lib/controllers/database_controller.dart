import 'package:firebase_database/firebase_database.dart';
import 'package:quickparked/models/parking.dart';
import 'package:quickparked/utils/distance_utils.dart';

typedef ParkingAway = DistanceWrapper<Parking>;

class DatabaseController {
  final _parkingsReference = FirebaseDatabase.instance.ref('parkings');

  Future<Set<Parking>> fetchParkings() async {
    var snapshot = await _parkingsReference.get();
    return snapshot.children
        .map((e) => Map<String, dynamic>.from(e.value as Map<Object?, Object?>))
        .map((e) => Parking.fromMap(e))
        .toSet();
  }

  DatabaseController._();
  static final DatabaseController _global = DatabaseController._();
  static DatabaseController get instance => _global;
}
