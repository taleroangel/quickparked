import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationException implements Exception {
  final String cause;
  LocationException({this.cause = "Location isn't enabled"});
}

mixin RequiresLocation {
  final Location location = Location();

  bool _locationIsEnabled = false;
  bool get locationIsEnabled => _locationIsEnabled;

  Future<void> startLocationService() async {
    // If it is not enabled, enable it, if it fails, throw error
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        _locationIsEnabled = false;
        throw LocationException(
            cause: "No se ha podido iniciar el servicio de ubicación");
      }
    }

    // Check for permission
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted ||
          permissionGranted == PermissionStatus.grantedLimited) {
      } else {
        _locationIsEnabled = false;
        throw LocationException(
            cause: "El permiso de ubicación no fue concedido");
      }
    }

    // Location is enabled
    location.changeSettings(interval: 10000);
    _locationIsEnabled = true;
  }

  void checkLocationService() async {
    if (!await location.serviceEnabled() || !await location.requestService()) {
      _locationIsEnabled = false;
    } else {
      _locationIsEnabled = true;
    }
  }

  Future<LatLng> getCurrentLocation() async {
    if (!locationIsEnabled) await startLocationService();
    var position = await location.getLocation();
    return LatLng(position.latitude!, position.longitude!);
  }
}
