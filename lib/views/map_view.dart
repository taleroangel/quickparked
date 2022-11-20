import 'package:flutter/material.dart';
import 'package:quickparked/models/user.dart' as quickparked;

class MapView extends StatelessWidget {
  final quickparked.User user;
  const MapView({required this.user, super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("QuickParked")),
        body: Center(child: Text(user.fullname)),
      );
}
