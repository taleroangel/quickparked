import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickparked/providers/parkings_provider.dart';
import 'package:quickparked/widgets/parking_selector.dart';

class BottomParkingsSheet extends StatelessWidget {
  const BottomParkingsSheet({super.key});

  static const initialWidgets = [
    Padding(
      padding: EdgeInsets.all(8.0),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: "Sugerencias\n", style: TextStyle(fontSize: 20.0)),
        TextSpan(text: "Parqueaderos cerca a tu ubicación")
      ])),
    ),
    Divider(color: Colors.black38),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParkingsProvider>();
    return DraggableScrollableSheet(
        minChildSize: 0.12,
        initialChildSize: 0.2,
        maxChildSize: 0.5,
        builder: (context, scrollController) => Container(
              padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 6.0,
                        spreadRadius: -1.0)
                  ]),
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: initialWidgets.length + provider.parkings.length,
                  itemBuilder: (context, index) {
                    if (index < initialWidgets.length) {
                      return initialWidgets[index];
                    } else {
                      return ParkingSelector(
                          parking:
                              provider.parkings[index - initialWidgets.length]);
                    }
                  }),
            ));
  }
}
