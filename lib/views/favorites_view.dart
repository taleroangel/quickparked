import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickparked/controllers/authentication_controller.dart';
import 'package:quickparked/providers/parkings_provider.dart';
import 'package:quickparked/widgets/parking_selector.dart';

class FavoritesView extends StatelessWidget {
  FavoritesView({super.key});

  final user = AuthenticationController.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ParkingsProvider>();
    final favorites = user.favoriteParkings(provider.parkings.values.toList());

    return Scaffold(
        appBar: AppBar(title: const Text("Parqueaderos Favoritos")),
        body: ListView.separated(
            itemBuilder: ((context, index) =>
                ParkingSelector(parking: favorites[index])),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: favorites.length));
  }
}
