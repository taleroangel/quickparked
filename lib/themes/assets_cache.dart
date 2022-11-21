import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssetsCache {
  static final Future<BitmapDescriptor> _iconLocationFuture =
      BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), 'assets/icons/location.png');

  final BitmapDescriptor iconLocation;
  AssetsCache._({required this.iconLocation});

  static AssetsCache? _global;

  /// Load assets before program starts
  /// Meant to be used before runApp()
  static Future<void> startAssets() async {
    var iconLocation = await _iconLocationFuture;
    _global = AssetsCache._(iconLocation: iconLocation);
  }

  static AssetsCache get instance => _global!;
}
