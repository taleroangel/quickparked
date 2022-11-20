import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickparked/models/user.dart' as quickparked;
import 'package:quickparked/widgets/credentials_field.dart';
import 'package:quickparked/widgets/quickparked_logo.dart';
import 'package:flutter/foundation.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  void attemptCreate(BuildContext context, String email, String password) =>
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        /* --------- Database real time --------- */
        final uuid = value.user!.uid;
        DatabaseReference ref = FirebaseDatabase.instance.ref('users/$uuid');
        quickparked.User newUser = quickparked.User(
          fullname: "Usuario",
          email: value.user!.email!,
          createdAt: DateTime.now().toString(),
          lastLogin: DateTime.now().toString(),
        );

        ScaffoldMessenger.of(context).clearSnackBars();
        /* --------- On user creation success --------- */
        ref.set(newUser.toJson()).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("La cuenta ha sido creada con éxito!"),
            behavior: SnackBarBehavior.floating,
          ));
          Navigator.of(context).pop();
        }).catchError((error) {
          log(error.toString(), level: DiagnosticLevel.error.index);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error.toString()),
            behavior: SnackBarBehavior.floating,
          ));
        });
      }) // Show error
          .catchError((e) {
        log("Failed account creation", level: DiagnosticLevel.error.index);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text.rich(TextSpan(children: [
            const TextSpan(
                text: "No se ha podido crear la cuenta\n",
                style: TextStyle(color: Colors.red)),
            TextSpan(text: e.message)
          ])),
          behavior: SnackBarBehavior.floating,
        ));
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: defaultTargetPlatform == TargetPlatform.android
            ? null
            : AppBar(
                title: const Text("Registro"),
              ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const QuickParkedLogo(),
            const SizedBox(
              height: 30,
            ),
            CredentialsField(
              legalCheck: true,
              title: "Regístrate",
              submitLabel: "Registrarse",
              onSubmit: (email, password) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text("Estamos creando tu cuenta, espera un momento..."),
                  behavior: SnackBarBehavior.floating,
                ));

                attemptCreate(context, email, password);
              },
            ),
          ]),
        ),
      );
}
