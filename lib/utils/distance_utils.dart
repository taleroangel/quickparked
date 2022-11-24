import 'dart:math';
import 'package:vector_math/vector_math.dart';

class DistanceWrapper<T> implements Comparable<DistanceWrapper<T>> {
  final double distance;
  final T object;
  DistanceWrapper({required this.distance, required this.object});

  @override
  int compareTo(DistanceWrapper<T> other) {
    return distance.compareTo(other.distance);
  }

  DistanceWrapper.fromCoordinates(double fromLatitude, double fromLongitude,
      double toLatitude, double toLongitude, this.object)
      : distance = DistanceUtils.calculateDistanceBetweenKm(
            fromLatitude, fromLongitude, toLatitude, toLongitude);
}

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
