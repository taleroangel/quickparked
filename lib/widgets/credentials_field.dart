import 'package:flutter/material.dart';
import 'package:quickparked/widgets/password_field.dart';

class CredentialsField extends StatefulWidget {
  final String title;
  final String submitLabel;
  final bool legalCheck;
  final Function(String email, String password) onSubmit;

  const CredentialsField(
      {required this.onSubmit,
      this.title = "Credenciales",
      this.submitLabel = "Enviar",
      this.legalCheck = false,
      super.key});

  @override
  State<CredentialsField> createState() => _CredentialsFieldState();
}

class _CredentialsFieldState extends State<CredentialsField> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool emailEmpty = false;
  bool passwordEmpty = false;
  bool boxChecked = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 25,
                fontWeight: FontWeight.w600),
          ),
          TextField(
            controller: emailController,
            enableSuggestions: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: "Correo Electrónico",
                errorText: emailEmpty ? 'Debes digitar un correo' : null,
                labelStyle: TextStyle(color: Theme.of(context).primaryColor)),
          ),
          PasswordField(
            label: "Contraseña: ",
            errorLabel: passwordEmpty ? "Debes digitar una contraseña" : null,
            controller: passwordController,
          ),
          const SizedBox(height: 20),
          if (widget.legalCheck)
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                  "Acepto los Términos de Servicio y Políticas de privacidad"),
              value: boxChecked,
              onChanged: (value) {
                setState(() {
                  boxChecked = !boxChecked;
                });
              },
            ),
          const SizedBox(height: 10),
          ElevatedButton(
              child: Text(widget.submitLabel),
              onPressed: () {
                // Show error on fields
                setState(() {
                  emailEmpty = emailController.text.isEmpty;
                  passwordEmpty = passwordController.text.isEmpty;
                });

                // Legal check
                if (widget.legalCheck && !boxChecked) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Debes aceptar los términos de servicio"),
                    behavior: SnackBarBehavior.floating,
                  ));
                  return;
                }

                // Make the call back
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  widget.onSubmit(
                      emailController.text, passwordController.text);
                }
              })
        ],
      );
}
