import 'dart:math';
import 'package:vector_math/vector_math.dart';

class DistanceUtils {
  static const _averageRadiusOfEarthKm = 6371;

  static double calculateDistanceBetweenKm(double fromLatitude,
      double fromLongitude, double toLatitude, double toLongitude) {
    var latDistance = radians(fromLatitude - toLatitude);
    var lngDistance = radians(fromLongitude - toLongitude);
    var a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(radians(fromLatitude)) *
            cos(radians(toLatitude)) *
            sin(lngDistance / 2) *
            sin(lngDistance / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return (_averageRadiusOfEarthKm * c).toDouble();
  }
}
