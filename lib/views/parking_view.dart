import 'package:flutter/material.dart';
import 'package:quickparked/models/parking.dart';

class ParkingView extends StatelessWidget {
  const ParkingView({required this.parking, super.key});
  final Parking parking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(parking.name)),
      body: Center(child: Text(parking.toString())),
    );
  }
}
