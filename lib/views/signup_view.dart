import 'package:flutter/material.dart';
import 'package:quick_parked/widgets/credentials_field.dart';
import 'package:quick_parked/widgets/quickparked_logo.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
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
                /* --------- Create account --------- */
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text("Estamos creando tu cuenta, espera un momento..."),
                  behavior: SnackBarBehavior.floating,
                ));

                //TODO Create account
              },
            ),
          ]),
        ),
      );
}
