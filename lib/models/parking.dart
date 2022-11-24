import 'package:quickparked/models/vehicle_type.dart';
import 'package:uuid/uuid.dart';

extension FeeParserToJson on Map<VehicleType, double> {
  Map<String, dynamic> toVehicleName() =>
      map((key, value) => MapEntry(key.name, (value as dynamic)));
}

extension FeeParserFromJson on Map<String, dynamic> {
  Map<VehicleType, double> fromVehicleName() => map((key, value) => MapEntry(
      VehicleType.values.firstWhere((e) =>
          e
              .toString()
              .substring(e.toString().indexOf('.') + 1, e.toString().length) ==
          key),
      (value as num).toDouble()));
}

class Parking {
  String uid;
  final String name;
  final String address;
  final int available;
  final Map<VehicleType, double> fees;
  final double latitude;
  final double longitude;

  Parking({
    String? uid,
    required this.name,
    required this.address,
    required this.available,
    required this.fees,
    required this.latitude,
    required this.longitude,
  }) : uid = uid ?? const Uuid().v4().toString();

  Map<String, dynamic> toMap() => <String, dynamic>{
        "uid": uid,
        "name": name,
        "address": address,
        "available": available,
        "fees": fees.toVehicleName(),
        "longitude": longitude,
        "latitude": latitude
      };

  Parking.fromMap(Map<String, dynamic> json)
      : uid = json["uid"] ?? const Uuid().v4().toString(),
        name = json["name"],
        address = json["address"],
        available = json["available"],
        fees = Map<String, dynamic>.from(json["fees"] as Map<Object?, Object?>)
            .fromVehicleName(),
        latitude = json["latitude"],
        longitude = json["longitude"];

  @override
  String toString() {
    return """\nParking ($uid):
    name: $name,
    address: $address,
    available: $available,
    fees: $fees,
    latitude: $latitude,
    longitude: $longitude\n""";
  }
}
