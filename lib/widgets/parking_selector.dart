import 'package:flutter/material.dart';
import 'package:quickparked/controllers/database_controller.dart';
import 'package:quickparked/views/parking_view.dart';

class ParkingSelector extends StatelessWidget {
  const ParkingSelector({required this.parking, super.key});
  final ParkingAway parking;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: parking.object.available == 0
            ? Image.asset("assets/images/quickparked_red.png")
            : Image.asset("assets/images/quickparked.png"),
        title: Text(parking.object.name),
        subtitle: Text("Se encuentra a ${parking.distance.round()} Km"),
        trailing: const Icon(Icons.directions, size: 40.0),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ParkingView(parking: parking.object),
        )),
      );
}
