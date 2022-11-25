import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickparked/models/parking.dart';
import 'package:quickparked/providers/parkings_provider.dart';

class ParkingView extends StatelessWidget {
  const ParkingView({required this.parking, super.key});
  final Parking parking;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ParkingsProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(parking.name)),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 5,
              child: GoogleMap(
                markers: {parking.createMarker()},
                liteModeEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(parking.latitude, parking.longitude),
                    zoom: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Image.asset(parking.available == 0
                  ? 'assets/icons/parking_unavailable.png'
                  : 'assets/icons/parking_available.png'),
            ),
            Text(
              parking.name,
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(parking.address),
            const Spacer(),
            Text.rich(
                TextSpan(style: const TextStyle(fontSize: 20.0), children: [
              TextSpan(
                  text: "Cupos disponibles: ",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              TextSpan(text: parking.available.toString())
            ])),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: parking.fees.length,
                  itemBuilder: (context, index) {
                    var feeType = parking.fees.keys.elementAt(index);
                    return ListTile(
                        leading: Icon(feeType.icon),
                        title: Text(feeType.name),
                        trailing: Text("${parking.fees[feeType]} \$/min"));
                  }),
            ),
            const Spacer(),
            if (parking.available != 0)
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.key),
                  label: const Text("Reservar")),
            if (parking.available == 0)
              ElevatedButton.icon(
                  onPressed: () {
                    provider.parkingAvailableNotify(parking);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Se te notificará cuando esté disponible"),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: const Icon(Icons.notification_important),
                  label: const Text("Avísame")),
            const Spacer()
          ]),
    );
  }
}
