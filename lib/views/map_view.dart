import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickparked/controllers/authentication_controller.dart';
import 'package:quickparked/controllers/database_controller.dart';
import 'package:quickparked/mixins/requires_location.dart';
import 'package:quickparked/models/parking.dart';
import 'package:quickparked/providers/parkings_provider.dart';
import 'package:quickparked/providers/profile_picture_provider.dart';
import 'package:quickparked/themes/assets_cache.dart';
import 'package:quickparked/views/parking_view.dart';
import 'package:quickparked/widgets/bottom_parkings_sheet.dart';
import 'package:quickparked/widgets/profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:quickparked/widgets/user_drawer.dart';

/// The actual view, with the Drawer button and the Map
class MapView extends StatelessWidget {
  const MapView({super.key});

  static const initialPosition = LatLng(4.628925, -74.064414);
  static const defaultZoom = 18.0;

  @override
  Widget build(BuildContext context) {
    context.read<ProfilePictureProvider>().updateProfilePicture();
    context.read<ParkingsProvider>().initialParkingSetup(initialPosition);
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: const UserDrawer(),
      body: SafeArea(
          child: Stack(
        children: [
          const _MapArea(),
          const BottomParkingsSheet(),
          Positioned(
              top: 10.0,
              left: 10.0,
              child: FloatingActionButton(
                heroTag: null,
                child: const Icon(Icons.list),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              )),
          const Positioned(
            top: 45,
            left: 45,
            child: ProfilePicture(size: 45),
          ),
        ],
      )),
    );
  }
}

/// The Map and Map related buttons, so scaffold doesn't rebuild every time
class _MapArea extends StatefulWidget {
  const _MapArea();

  static Marker markerFromParking(Parking parking, Function() onTap) => Marker(
      markerId: MarkerId(parking.uid),
      position: LatLng(parking.latitude, parking.longitude),
      onTap: onTap,
      visible: true,
      icon: parking.available == 0
          ? AssetsCache.instance.iconParkingUnavailable
          : AssetsCache.instance.iconParkingAvailable);

  @override
  State<_MapArea> createState() => __MapAreaState();
}

class __MapAreaState extends State<_MapArea> with RequiresLocation {
  final _controller = Completer<GoogleMapController>();
  final locationSubscription = Completer<StreamSubscription>();
  bool moveCamera = true;

  Marker? _userPositionMarker;

  setUserLocation(LatLng userPosition, {bool cameraMove = false}) {
    setState(() {
      _userPositionMarker = (Marker(
          markerId: const MarkerId("user"),
          position: userPosition,
          icon: AssetsCache.instance.iconLocation));
    });

    AuthenticationController.instance.userUpdateInfo({
      "latitude": userPosition.latitude,
      "longitude": userPosition.longitude
    });

    if (moveCamera || cameraMove) {
      _controller.future.then((controller) {
        controller.animateCamera(
            CameraUpdate.newLatLngZoom(userPosition, MapView.defaultZoom));
      });
    }
  }

  @override
  void dispose() {
    locationSubscription.future.then((value) => value.cancel());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParkingsProvider>();
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, contraints) => Listener(
            onPointerDown: (event) => (moveCamera = false),
            child: SizedBox(
              height: contraints.maxHeight * 0.93,
              child: GoogleMap(
                  mapToolbarEnabled: false,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) async {
                    _controller.complete(controller);
                    try {
                      await startLocationService();
                      // Create the location subscription
                      locationSubscription
                          .complete(location.onLocationChanged.listen((event) {
                        final location =
                            LatLng(event.latitude!, event.longitude!);
                        provider.setUserLocation(location);
                        setUserLocation(location);
                      }));
                    } on LocationException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "Error en el mapa\n",
                              style: TextStyle(color: Colors.red)),
                          TextSpan(text: e.cause)
                        ])),
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  },
                  markers: {
                    if (_userPositionMarker != null) _userPositionMarker!,
                    ...(provider.parkings
                        .map((e) => _MapArea.markerFromParking(e.object, () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ParkingView(parking: e.object),
                              ));
                            })))
                  },
                  initialCameraPosition: const CameraPosition(
                      target: MapView.initialPosition,
                      zoom: MapView.defaultZoom)),
            ),
          ),
        ),
        if (locationIsEnabled)
          Positioned(
              top: 10.0,
              right: 10.0,
              child: FloatingActionButton(
                heroTag: null,
                child: const Icon(Icons.my_location),
                onPressed: () async {
                  final userPosition = await getCurrentLocation();
                  setUserLocation(userPosition, cameraMove: true);
                  provider.setUserLocation(userPosition);
                  moveCamera = true;
                },
              )),
      ],
    );
  }
}
