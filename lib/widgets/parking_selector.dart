import 'package:flutter/material.dart';
import 'package:quickparked/controllers/authentication_controller.dart';
import 'package:quickparked/models/parking.dart';
import 'package:quickparked/views/parking_view.dart';

class ParkingSelector extends StatefulWidget {
  const ParkingSelector({required this.parking, super.key});
  final Parking parking;

  @override
  State<ParkingSelector> createState() => _ParkingSelectorState();
}

class _ParkingSelectorState extends State<ParkingSelector> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    isFavorite = AuthenticationController.instance.currentUser!.favorites
        .contains(widget.parking.uid);
    return ListTile(
      leading: widget.parking.available == 0
          ? Image.asset("assets/images/quickparked_red.png")
          : Image.asset("assets/images/quickparked.png"),
      title: Text(widget.parking.name),
      subtitle: Text(
          "Se encuentra a ${widget.parking.distance.toDouble().toStringAsFixed(2)} Km"),
      trailing: IconButton(
          onPressed: () {
            setState(() {
              if (!isFavorite) {
                AuthenticationController.instance
                    .addFavorite(widget.parking.uid);
                isFavorite = true;
              } else {
                AuthenticationController.instance
                    .removeFavorite(widget.parking.uid);
                isFavorite = false;
              }
            });
          },
          icon: Icon(
            Icons.favorite_rounded,
            size: 30.0,
            color: isFavorite ? Colors.red : Colors.grey,
          )),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ParkingView(parking: widget.parking),
      )),
    );
  }
}
