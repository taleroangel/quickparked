import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickparked/controllers/authentication_controller.dart';
import 'package:quickparked/views/login_view.dart';
import 'package:quickparked/mixins/requires_location.dart';
import 'package:quickparked/models/user.dart' as quickparked;

class _UserDrawer extends StatelessWidget {
  // ignore: unused_element
  _UserDrawer({super.key});
  final quickparked.User user = AuthenticationController.instance.currentUser!;

  void showExit(BuildContext context, Function() doExit) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Cerrar sesión"),
            content: const Text("¿Estas seguro que deseas cerrar sesión?"),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).hintColor),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar")),
              ElevatedButton(
                  child: const Text("Cerrar sesión"),
                  onPressed: () => AuthenticationController.instance
                      .logout(onSuccess: doExit(), onError: (_) {}))
            ],
          ));

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Bienvenido ${user.fullname}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Divider(
                  height: 10.0,
                ),
                /* --------- Buttons --------- */
                const ListTile(
                  iconColor: Colors.black,
                  leading: Icon(Icons.home_rounded),
                  title: Text("Mi Ciudad"),
                ),
                const ListTile(
                  iconColor: Colors.black,
                  leading: Icon(Icons.favorite),
                  title: Text("Favoritos"),
                ),
                const ListTile(
                  iconColor: Colors.black,
                  leading: Icon(Icons.settings),
                  title: Text("Configuraciones"),
                ),
                ListTile(
                  iconColor: Colors.black,
                  leading: const Icon(Icons.logout),
                  title: const Text("Cerrar Sesión"),
                  onTap: () => showExit(
                      context,
                      () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ))),
                ),
              ],
            ),
          ),
        ),
      );
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  static const initialZoom = 18.0;
  static const initialPosition = LatLng(4.628360, -74.064639);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with RequiresLocation {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Set<Marker> mapMarkers = <Marker>{};

  void showLocationError(context, exception) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text.rich(TextSpan(children: [
      const TextSpan(
          text: "Error al obtener la ubicación\n",
          style: TextStyle(color: Colors.red)),
      TextSpan(text: (exception as LocationException).cause),
    ]))));
  }

  @override
  void initState() {
    startLocationService().then((_) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        drawer: _UserDrawer(),
        body: SafeArea(
          child: Stack(children: [
            GoogleMap(
              mapType: MapType.normal,
              markers: mapMarkers,
              initialCameraPosition: const CameraPosition(
                  target: MapView.initialPosition, zoom: MapView.initialZoom),
              onMapCreated: (controller) {},
            ),
            Positioned(
                top: 10.0,
                left: 10.0,
                child: FloatingActionButton(
                  heroTag: null,
                  child: const Icon(Icons.list),
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                )),
            if (locationIsEnabled)
              Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: FloatingActionButton(
                    heroTag: null,
                    child: const Icon(Icons.my_location),
                    onPressed: () {},
                  )),
          ]),
        ),
      );
}
