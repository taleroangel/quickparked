import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickparked/models/parking.dart';
import 'package:quickparked/utils/distance_utils.dart';

class ParkingsProvider with ChangeNotifier {
  LatLng _currentLocation = const LatLng(0, 0);
  Map<String, Parking> _parkings = {};
  Map<String, Parking> get parkings => _parkings;
  List<Parking> get ordered => parkings.values.toList()..sort();

  final _subscription = Completer<StreamSubscription<DatabaseEvent>>();
  final _listeners = <String, StreamSubscription<DatabaseEvent>>{};

  static const minimumTraveledDistance = 1.0;

  parkingAvailableNotify(Parking parking) {
    _listeners.putIfAbsent(
        parking.uid,
        () => FirebaseDatabase.instance
                .ref('parkings/${parking.uid}')
                .onValue
                .listen(
              (event) {
                if (Map<String, dynamic>.from((event.snapshot.value
                        as Map<Object?, Object?>))['available'] !=
                    0) {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 10,
                          channelKey: 'quickparked_parking_available',
                          title:
                              'El parqueadero "${parking.name}" tiene cupos disponibles!',
                          body: 'Entra a QuickParked y reserva un cupo',
                          actionType: ActionType.DisabledAction));

                  _listeners[parking.uid]!.cancel();
                  _listeners.remove(parking.uid);
                }
              },
            ));
  }

  void startListening() {
    if (!_subscription.isCompleted) {
      _subscription.complete(
          FirebaseDatabase.instance.ref('parkings').onValue.listen((event) {
        _parkings = (event.snapshot.value as Map).cast<String, Map>().map(
            (key, value) => MapEntry(
                key,
                Parking.fromMap(value.cast<String, dynamic>())
                  ..calculateDistance(
                      _currentLocation.latitude, _currentLocation.longitude)));
        notifyListeners();
      }));
    }
  }

  void setUserLocation(LatLng location) async {
    var distance = DistanceUtils.calculateDistanceBetweenKm(
        location.latitude,
        location.longitude,
        _currentLocation.latitude,
        _currentLocation.longitude);

    if (distance < minimumTraveledDistance) {
      return;
    }

    _currentLocation = location;
    _parkings.forEach(
      (key, value) => value.calculateDistance(
          _currentLocation.latitude, _currentLocation.longitude),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.future.then((value) => value.cancel());
    super.dispose();
  }
}
