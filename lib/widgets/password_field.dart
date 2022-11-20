import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String label;
  final String? errorLabel;
  final TextEditingController controller;
  const PasswordField(
      {this.label = "Contraseña: ",
      this.errorLabel,
      required this.controller,
      super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool passwordIsVisible = false;

  @override
  Widget build(BuildContext context) => TextField(
        controller: widget.controller,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: !passwordIsVisible,
        decoration: InputDecoration(
            errorText: widget.errorLabel,
            suffixIcon: IconButton(
              icon: Icon(
                  !passwordIsVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() {
                passwordIsVisible = !passwordIsVisible;
              }),
            ),
            labelText: widget.label,
            labelStyle: TextStyle(color: Theme.of(context).primaryColor)),
      );
}
