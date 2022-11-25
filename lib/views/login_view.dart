import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickparked/controllers/authentication_controller.dart';
import 'package:quickparked/views/map_view.dart';
import 'package:quickparked/views/signup_view.dart';
import 'package:quickparked/widgets/credentials_field.dart';
import 'package:quickparked/widgets/quickparked_logo.dart';

class _RecoverPassword extends StatefulWidget {
  const _RecoverPassword({Key? key}) : super(key: key);

  @override
  State<_RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<_RecoverPassword> {
  final recoverController = TextEditingController();
  bool recoverEmpty = false;

  void doResetPassword(BuildContext context, String email) =>
      AuthenticationController.instance.recoverPassword(email, onSuccess: () {},
          onError: (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text.rich(TextSpan(children: [
            const TextSpan(
                text: "No se ha podido restaurar la constraseña\n",
                style: TextStyle(color: Colors.red)),
            TextSpan(text: error.toString())
          ])),
          behavior: SnackBarBehavior.floating,
        ));
      });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Recupera tu contraseña",
                style: TextStyle(fontSize: 25),
              ),
              const Text(
                  "Digita tu correo, ahí te enviaremos las instrucciones para recuperar la contraseña."),
              const Divider(),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: recoverController,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                      errorText: recoverEmpty ? 'Debes digitar un email' : null,
                      labelText: "Correo Electrónico",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
              ElevatedButton(
                child: const Text("Recupera mi contraseña"),
                onPressed: () {
                  if (recoverController.text.isEmpty) {
                    setState(() {
                      recoverEmpty = true;
                    });
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("Revisa tu correo para continuar la recuperación"),
                    behavior: SnackBarBehavior.floating,
                  ));

                  doResetPassword(context, recoverController.text);
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      );
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  void attemptLogin(BuildContext context, String email, String password) {
    AuthenticationController.instance.login(email, password, onSuccess: () {
      // Show message
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sesión iniciada correctamente!"),
        behavior: SnackBarBehavior.floating,
      ));
      // Create MapView
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MapView(),
      ));
    }, onError: (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text.rich(TextSpan(children: [
          const TextSpan(
              text: "No se ha podido iniciar sesión\n",
              style: TextStyle(color: Colors.red)),
          TextSpan(text: (e as FirebaseAuthException).message)
        ])),
        behavior: SnackBarBehavior.floating,
      ));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const QuickParkedLogo(),
              const SizedBox(
                height: 30,
              ),
              CredentialsField(
                  title: "Iniciar Sesión",
                  submitLabel: "Continuar",
                  onSubmit: (email, password) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Estamos iniciando tu sesión"),
                      behavior: SnackBarBehavior.floating,
                    ));

                    // Try to signin
                    attemptLogin(context, email, password);
                  }),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                child: const Text("¿Olvidaste tu contraseña?"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => const _RecoverPassword());
                },
              ),
              TextButton(
                child: const Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "¿Aún no tienes cuenta?",
                      style: TextStyle(color: Colors.black87)),
                  WidgetSpan(
                      child: SizedBox(
                    width: 10,
                  )),
                  TextSpan(text: "Registrate")
                ])),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignupView(),
                  ));
                },
              )
            ],
          ),
        ),
      );
}
