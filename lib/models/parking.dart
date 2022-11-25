import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickparked/models/vehicle_type.dart';
import 'package:quickparked/themes/assets_cache.dart';
import 'package:quickparked/utils/distance_utils.dart';
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

class Parking implements Comparable {
  double distance;
  String uid;
  final String name;
  final String address;
  final int available;
  final Map<VehicleType, double> fees;
  final double latitude;
  final double longitude;

  Parking({
    this.distance = 0.0,
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
      : distance = 0.0,
        uid = json["uid"] ?? const Uuid().v4().toString(),
        name = json["name"],
        address = json["address"],
        available = json["available"],
        latitude = json["latitude"],
        longitude = json["longitude"],
        fees = Map<String, dynamic>.from(json["fees"] as Map<Object?, Object?>)
            .fromVehicleName();

  @override
  int compareTo(other) {
    return distance.compareTo(other.distance);
  }

  @override
  String toString() {
    return """\nParking ($uid):
    distance: $distance
    name: $name,
    address: $address,
    available: $available,
    fees: $fees,
    latitude: $latitude,
    longitude: $longitude""";
  }

  Marker createMarker({Function()? onTap}) => Marker(
      markerId: MarkerId(uid),
      position: LatLng(latitude, longitude),
      icon: available == 0
          ? AssetsCache.instance.iconParkingUnavailable
          : AssetsCache.instance.iconParkingAvailable,
      infoWindow: InfoWindow(title: name),
      onTap: onTap);

  void calculateDistance(double latitude, double longitude) {
    distance = DistanceUtils.calculateDistanceBetweenKm(
        latitude, longitude, this.latitude, this.longitude);
  }
}
