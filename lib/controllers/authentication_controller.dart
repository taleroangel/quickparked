import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_database/firebase_database.dart' as firebase;
import 'package:firebase_storage/firebase_storage.dart' as firebase;
import 'package:flutter/services.dart';
import 'package:quickparked/models/user.dart' as quickparked;

class AuthenticationException implements Exception {
  String cause;
  AuthenticationException({this.cause = "User is not logged int"});
}

class AuthenticationController {
  quickparked.User? _currentUser;
  quickparked.User? get currentUser => _currentUser;

  /// Profile pictures storage bucket
  final _profileStorage = firebase.FirebaseStorage.instanceFor(
          bucket: "gs://quickparked.appspot.com")
      .ref('/users');

  /// Check if user is currently logged in
  bool get isLoggedIn => (_currentUser != null);

  /// Get the current user profile picture
  ///
  /// Throws an [AuthenticationException] if the user is not logged in
  Future<Uint8List?> getProfilePicture() async {
    try {
      return _profileStorage
          .child('${AuthenticationController.instance.getUserUID()!}.jpg')
          .getData();
    } on NullThrownError catch (_) {
      throw AuthenticationException();
    }
  }

  /// Update the user's profile picture
  ///
  /// Throws an [AuthenticationException] if the user is not logged in
  Future<void> uploadProfilePicture(Uint8List data) async {
    try {
      await _profileStorage
          .child('${AuthenticationController.instance.getUserUID()!}.jpg')
          .putData(data);
    } on NullThrownError catch (_) {
      throw AuthenticationException();
    }
  }

  /// Get the user UUID
  /// Null if the user is not logged in
  String? getUserUID() {
    return firebase.FirebaseAuth.instance.currentUser?.uid;
  }

  /// Sync firebase auth with application auth
  Future<void> syncWithFirebase() async {
    if (firebase.FirebaseAuth.instance.currentUser != null) {
      _currentUser = await _fetchUser();
    } else {
      _currentUser = null;
    }
  }

  /// Fetch user information from firebase
  Future<quickparked.User> _fetchUser() async {
    try {
      // Fetch user and it's nullity
      firebase.User firebaseUser = firebase.FirebaseAuth.instance.currentUser!;
      return quickparked.User.fetchUserFromFirebase(firebaseUser.uid);
    } on NullThrownError catch (_) {
      throw AuthenticationException();
    }
  }

  Future<void> userUpdateInfo(Map<String, dynamic> info) async {
    try {
      firebase.User user = firebase.FirebaseAuth.instance.currentUser!;
      await firebase.FirebaseDatabase.instance
          .ref('users/${user.uid}')
          .update(info);
      syncWithFirebase();
    } on NullThrownError catch (_) {
      throw AuthenticationException();
    }
  }

  /// Try to login to an account and fetch it' information
  void login(String email, String password,
      {Function()? onSuccess, Function(dynamic)? onError}) async {
    try {
      await firebase.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Make user active
      userUpdateInfo({
        "active": true,
      });

      await syncWithFirebase();
      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onError != null) onError(e);
    }
  }

  void logout() async {
    userUpdateInfo({
      "active": false,
      "latitude": 0,
      "longitude": 0,
    });

    // signout and sync with firebase
    await firebase.FirebaseAuth.instance.signOut();
    await syncWithFirebase();
  }

  void recoverPassword(String email,
      {Function()? onSuccess, Function(dynamic)? onError}) async {
    try {
      await firebase.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onError != null) onError(e);
    }
  }

  /// Try to create an account on firebase
  void createAccount(String email, String password,
      {Function()? onSuccess, Function(dynamic)? onError}) async {
    try {
      // Try to create account
      firebase.UserCredential credentials = await firebase.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create database information
      final uuid = credentials.user!.uid;
      firebase.DatabaseReference ref =
          firebase.FirebaseDatabase.instance.ref('users/$uuid');
      final quickparked.User newUser = quickparked.User(
        fullname: "Usuario",
        email: credentials.user!.email!,
        createdAt: DateTime.now().toString(),
        lastLogin: DateTime.now().toString(),
      );

      // Push data to database
      await ref.set(newUser.toJson());

      if (firebase.FirebaseAuth.instance.currentUser != null) {
        logout();
      }

      // Success
      await syncWithFirebase();
      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onError != null) onError(e);
    }
  }

  // This class is a Singleton
  AuthenticationController._();
  static final AuthenticationController _global = AuthenticationController._();
  static AuthenticationController get instance => _global;
}
