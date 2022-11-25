import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:quickparked/controllers/authentication_controller.dart';
import 'package:quickparked/views/favorites_view.dart';
import 'package:quickparked/views/login_view.dart';
import 'package:quickparked/views/settings_view.dart';
import 'package:quickparked/models/user.dart' as quickparked;
import 'package:quickparked/widgets/profile_picture.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  Future<void> showExit(BuildContext context, Function() doExit) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Cerrar sesión"),
              content: const Text("¿Estas seguro que deseas cerrar sesión?"),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).hintColor),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancelar")),
                ElevatedButton(
                    child: const Text("Cerrar sesión"),
                    onPressed: () async {
                      AuthenticationController.instance.logout();
                      doExit();
                    })
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final quickparked.User user =
        AuthenticationController.instance.currentUser!;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Hero(tag: "profile", child: ProfilePicture(size: 85)),
              ),
              Text(
                'Bienvenido ${user.fullname.split(' ')[0]}',
                style: const TextStyle(fontSize: 20, height: 0),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 16.0,
                child: Divider(),
              ),
              /* --------- Buttons --------- */
              ListTile(
                iconColor: Colors.black,
                leading: const Icon(Icons.home_rounded),
                title: const Text("Mi Ciudad"),
                onTap: () {
                  // TODO Create actual HomePage
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 10,
                          channelKey: 'quickparked_parking_available',
                          title: 'Saludos desde QuickParked',
                          body: 'Esta es una notificación',
                          actionType: ActionType.DisabledAction));
                },
              ),
              ListTile(
                iconColor: Colors.black,
                leading: const Icon(Icons.favorite),
                title: const Text("Favoritos"),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FavoritesView(),
                )),
              ),
              ListTile(
                iconColor: Colors.black,
                leading: const Icon(Icons.settings),
                title: const Text("Configuraciones"),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                )),
              ),
              ListTile(
                iconColor: Colors.black,
                leading: const Icon(Icons.logout),
                title: const Text("Cerrar Sesión"),
                onTap: () {
                  showExit(context, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginView()),
                        (route) => false);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
