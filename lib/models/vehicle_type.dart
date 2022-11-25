import 'package:flutter/material.dart';

enum VehicleType {
  car(name: "Automóvil", icon: Icons.directions_car_filled_rounded),
  motorcycle(name: "Motocicleta", icon: Icons.motorcycle_rounded),
  bike(name: "Bicicleta", icon: Icons.pedal_bike_rounded),
  electric(name: "Eléctrico", icon: Icons.electric_car_rounded);

  final String name;
  final IconData icon;
  const VehicleType({required this.name, required this.icon});
}
