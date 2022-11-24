import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssetsCache {
  static Future<BitmapDescriptor> getAssetAsBitmap(String asset) =>
      BitmapDescriptor.fromAssetImage(const ImageConfiguration(), asset);

  final BitmapDescriptor iconLocation;
  final BitmapDescriptor iconParkingAvailable;
  final BitmapDescriptor iconParkingUnavailable;
  AssetsCache._(
      {required this.iconLocation,
      required this.iconParkingAvailable,
      required this.iconParkingUnavailable});

  static AssetsCache? _global;

  /// Load assets before program starts
  /// Meant to be used before runApp()
  static Future<void> startAssets() async {
    var iconLocation = await getAssetAsBitmap('assets/icons/location.png');
    var iconParkingAvailable =
        await getAssetAsBitmap('assets/icons/parking_available.png');
    var iconParkingUnavailable =
        await getAssetAsBitmap('assets/icons/parking_unavailable.png');
    _global = AssetsCache._(
        iconLocation: iconLocation,
        iconParkingAvailable: iconParkingAvailable,
        iconParkingUnavailable: iconParkingUnavailable);
  }

  static AssetsCache get instance => _global!;
}
