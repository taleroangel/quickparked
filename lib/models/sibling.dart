import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickparked/themes/assets_cache.dart';

class Sibling {
  final String fullname;
  final bool active;
  final double latitude;
  final double longitude;

  const Sibling({
    required this.fullname,
    this.active = false,
    this.latitude = 0,
    this.longitude = 0,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        "fullname": fullname,
        "active": active,
        "latitude": latitude,
        "longitude": longitude
      };

  Sibling.fromMap(Map<String, dynamic> json)
      : fullname = json['fullname'] ?? "Usuario",
        active = json['active'] ?? false,
        latitude = json['latitude']?.toDouble() ?? 0,
        longitude = json['longitude']?.toDouble() ?? 0;

  Marker createMarker({Function()? onTap, required String uuid}) => Marker(
      markerId: MarkerId(uuid),
      icon: AssetsCache.instance.iconSibling,
      infoWindow: InfoWindow(title: fullname),
      position: LatLng(latitude, longitude),
      visible: true,
      onTap: onTap);
}
