// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:quickparked/mixins/requires_location.dart';
import 'package:quickparked/providers/profile_picture_provider.dart';
import 'package:quickparked/themes/assets_cache.dart';
import 'package:quickparked/widgets/profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:quickparked/widgets/user_drawer.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfilePictureProvider>().updateProfilePicture();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: const UserDrawer(),
      body: SafeArea(
          child: Stack(
        children: [
          const _MapArea(),
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

class _MapArea extends StatefulWidget {
  const _MapArea({super.key});

  @override
  State<_MapArea> createState() => __MapAreaState();

  static const initialPosition = LatLng(4.628925, -74.064414);
  static const defaultZoom = 18.0;
}

class __MapAreaState extends State<_MapArea> with RequiresLocation {
  final _controller = Completer<GoogleMapController>();
  final locationSubscription = Completer<StreamSubscription>();
  bool moveCamera = true;
  Marker? _userPositionMarker;
  final _parkingMarkers = <Marker>{};

  setUserLocation(LatLng userPosition, {bool cameraMove = false}) {
    setState(() {
      _userPositionMarker = (Marker(
          markerId: MarkerId("user"),
          position: userPosition,
          icon: AssetsCache.instance.iconLocation));
    });

    if (moveCamera || cameraMove) {
      _controller.future.then((controller) {
        controller.animateCamera(
            CameraUpdate.newLatLngZoom(userPosition, _MapArea.defaultZoom));
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
    return Stack(
      children: [
        Listener(
          onPointerDown: (event) => (moveCamera = false),
          child: GoogleMap(
              onMapCreated: (controller) async {
                _controller.complete(controller);
                try {
                  final userPosition = await getCurrentLocation();
                  setUserLocation(userPosition, cameraMove: true);
                  locationSubscription
                      .complete(location.onLocationChanged.listen((event) {
                    setUserLocation(LatLng(event.latitude!, event.longitude!));
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
                ..._parkingMarkers
              },
              initialCameraPosition: CameraPosition(
                  target: _MapArea.initialPosition,
                  zoom: _MapArea.defaultZoom)),
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
                  moveCamera = true;
                },
              )),
      ],
    );
  }
}
