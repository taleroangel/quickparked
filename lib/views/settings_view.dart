import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickparked/controllers/authentication_controller.dart';
import 'package:quickparked/providers/profile_picture_provider.dart';
import 'package:quickparked/widgets/profile_picture.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> uploadPhoto(ImageSource source) async {
    // Request file
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file = await imagePicker.pickImage(source: source);
    // If file is not valid
    if (file == null) return;
    Uint8List filebytes = await file.readAsBytes();
    // Upload file
    await AuthenticationController.instance.uploadProfilePicture(filebytes);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Configuraciones")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  // Profile image
                  const Hero(
                    tag: "profile",
                    child: ProfilePicture(
                      size: 230,
                    ),
                  ),

                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: FloatingActionButton(
                        heroTag: null,
                        child: const Icon(Icons.camera),
                        onPressed: () =>
                            uploadPhoto(ImageSource.camera).then((_) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "Se ha actualizado correctamente la imágen de perfil"),
                            behavior: SnackBarBehavior.floating,
                          ));
                          context
                              .read<ProfilePictureProvider>()
                              .updateProfilePicture();
                        }),
                      )),

                  Positioned(
                      left: 0,
                      bottom: 0,
                      child: FloatingActionButton(
                          heroTag: null,
                          child: const Icon(Icons.photo),
                          onPressed: () =>
                              uploadPhoto(ImageSource.gallery).then((_) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Se ha actualizado correctamente la imágen de perfil"),
                                  behavior: SnackBarBehavior.floating,
                                ));
                                context
                                    .read<ProfilePictureProvider>()
                                    .updateProfilePicture();
                              })))
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.0),
                child: _UserForm(),
              ),
            ],
          ),
        ),
      );
}

class _UserForm extends StatefulWidget {
  const _UserForm({
    Key? key,
  }) : super(key: key);

  static final RegExp carPlate =
      RegExp('[a-zA-Z]{3}[0-9]{3}', caseSensitive: false);
  static final RegExp motorPlate =
      RegExp('[a-zA-Z]{3}[0-9]{2}[a-zA-Z]', caseSensitive: false);

  @override
  State<_UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<_UserForm> {
  final _formKey = GlobalKey<FormState>();

  final user = AuthenticationController.instance.currentUser!;
  late String fullname = user.fullname;
  late int? phone = user.phone;
  late String? vehicle = user.vehicle;

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            spacing: 20,
            runSpacing: 15,
            children: [
              TextFormField(
                initialValue: user.fullname,
                validator: ((value) =>
                    value!.isEmpty ? "No puede estar vacío" : null),
                onSaved: (newValue) => (fullname = newValue!),
                enableSuggestions: true,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                ),
              ),
              // Teléfono
              TextFormField(
                initialValue: user.phone?.toString(),
                enableSuggestions: true,
                keyboardType: TextInputType.phone,
                onSaved: (newValue) =>
                    phone = (newValue == null ? null : int.tryParse(newValue)),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  labelText: 'Teléfono',
                ),
              ),
              // Placas
              TextFormField(
                initialValue: user.vehicle,
                enableSuggestions: true,
                keyboardType: TextInputType.text,
                onSaved: (newValue) => (vehicle = newValue),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp('[a-z0-9]', caseSensitive: false)),
                ],
                validator: (value) {
                  if ((value != null) &&
                      (value.isNotEmpty) &&
                      ((value.length != 6) ||
                          !_UserForm.carPlate.hasMatch(value) &&
                              !_UserForm.motorPlate.hasMatch(value))) {
                    return "No es un placa válida";
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.motorcycle),
                  border: OutlineInputBorder(),
                  labelText: 'Placa',
                ),
              ),

              Center(
                child: ElevatedButton(
                    onPressed: () {
                      // Validar
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        AuthenticationController.instance
                            .userUpdateInfo({
                              "fullname": fullname,
                              "phone": phone,
                              "vehicle": vehicle!.isEmpty ? null : vehicle
                            })
                            .then((value) => ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "El usuario ha sido actualizado con éxito!"),
                                  behavior: SnackBarBehavior.floating,
                                )))
                            .catchError((e) => ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "El usuario no ha podido ser actualizado"),
                                  behavior: SnackBarBehavior.floating,
                                )));
                      }
                    },
                    child: const Text("Guardar Cambios")),
              )
            ]),
      );
}
