import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_database/firebase_database.dart' as firebase;
import 'package:quickparked/models/user.dart' as quickparked;

class AuthenticationException implements Exception {
  String cause;
  AuthenticationException(this.cause);
}

class AuthenticationController {
  quickparked.User? _currentUser;
  quickparked.User? get currentUser => _currentUser;

  bool get isLoggedIn => (_currentUser != null);

  Future<void> syncWithFirebase() async {
    if (firebase.FirebaseAuth.instance.currentUser != null) {
      _currentUser = await _fetchUser();
    } else {
      _currentUser = null;
    }
  }

  // Fetch user information from firebase
  Future<quickparked.User> _fetchUser() async {
    // Fetch user and it's nullity
    firebase.User? firebaseUser = firebase.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      throw AuthenticationException("User is not logged in");
    }
    // Return new user
    return quickparked.User.fetchUserFromFirebase(firebaseUser.uid);
  }

  /// Try to login to an account and fetch it' information
  void login(String email, String password,
      {Function()? onSuccess, Function(dynamic)? onError}) async {
    try {
      await firebase.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await syncWithFirebase();
      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onError != null) onError(e);
    }
  }

  void logout({Function()? onSuccess, Function(dynamic)? onError}) async {
    try {
      await firebase.FirebaseAuth.instance.signOut();
      await syncWithFirebase();
      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onError != null) onError(e);
    }
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
