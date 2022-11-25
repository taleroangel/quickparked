import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:quickparked/controllers/authentication_controller.dart';
import 'package:quickparked/models/sibling.dart';

class SiblingsProvider with ChangeNotifier {
  final _subscriptions = Completer<StreamSubscription<DatabaseEvent>>();

  Map<String, Sibling> _siblings = <String, Sibling>{};
  Map<String, Sibling> get siblings => _siblings;

  void startListening() {
    if (!_subscriptions.isCompleted) {
      _subscriptions.complete(
          FirebaseDatabase.instance.ref('/users').onValue.listen((event) {
        _siblings = (event.snapshot.value as Map).cast<String, dynamic>().map(
            (key, value) => MapEntry(
                key, Sibling.fromMap((value as Map).cast<String, dynamic>())));
        _siblings.removeWhere((key, value) => !value.active);
        _siblings.removeWhere((key, value) =>
            (key == AuthenticationController.instance.getUserUID()));
        notifyListeners();
      }));
    }
  }

  @override
  void dispose() {
    _subscriptions.future.then((value) => value.cancel());
    super.dispose();
  }
}
