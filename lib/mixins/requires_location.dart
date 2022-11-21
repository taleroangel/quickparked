import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationException implements Exception {
  String cause;
  LocationException(this.cause);
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
        log("Location service STOPPED", level: DiagnosticLevel.debug.index);
        throw LocationException(
            "No se ha podido iniciar el servicio de ubicación");
      }
    }

    // Check for permission
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted ||
          permissionGranted == PermissionStatus.grantedLimited) {
        log("Location permission ACCEPTED", level: DiagnosticLevel.debug.index);
      } else {
        _locationIsEnabled = false;
        log("Location permission DENIED", level: DiagnosticLevel.debug.index);
        throw LocationException("El permiso de Ubicación no fue concedido");
      }
    }

    // Location is enabled
    _locationIsEnabled = true;
  }

  Future<LatLng> getCurrentLocation() async {
    if (!locationIsEnabled) throw LocationException("Location isn't enabled");
    var position = await location.getLocation();
    return LatLng(position.latitude!, position.longitude!);
  }
}
