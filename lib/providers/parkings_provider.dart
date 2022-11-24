import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickparked/controllers/database_controller.dart';
import 'package:quickparked/utils/distance_utils.dart';

class ParkingsProvider with ChangeNotifier {
  LatLng _userLocation = const LatLng(0, 0);
  List<ParkingAway> _parkings = const [];
  List<ParkingAway> get parkings => _parkings;

  static const minimumTraveledDistance = 1.0;

  void initialParkingSetup(LatLng initialLocation) async {
    _parkings = (await DatabaseController.instance.fetchParkings())
        .map((e) => DistanceWrapper(distance: 0.0, object: e))
        .toList();
    setUserLocation(initialLocation);
    log("Parkings information LOADED");
  }

  void setUserLocation(LatLng location) async {
    var distance = DistanceUtils.calculateDistanceBetweenKm(location.latitude,
        location.longitude, _userLocation.latitude, _userLocation.longitude);
    if (distance < minimumTraveledDistance) {
      return;
    }

    _userLocation = location;
    _parkings = _parkings
        .map((e) => e.object)
        .map((e) => DistanceWrapper.fromCoordinates(e.latitude, e.longitude,
            _userLocation.latitude, _userLocation.longitude, e))
        .toList();
    _parkings.sort();
    log("Parking provider requested update on Parking Lists");
    notifyListeners();
  }
}
