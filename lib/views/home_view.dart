import 'package:flutter/material.dart';
import 'package:quick_parked/views/login_view.dart';
import 'package:quick_parked/widgets/quickparked_logo.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /* Show QuickParked logo */
              const QuickParkedLogo(),
              /* Show additional information */
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: const Text(
                  "¡Bienvenido a QuickParked!",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text(
                "QuickParked te muestra todos los parqueaderos en tu ubicación actual o una en específico. Elije la que más te convenga teniendo en cuenta su tarifa o cercanía",
                style: TextStyle(color: Colors.black, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Container(
                  margin: const EdgeInsets.all(20),
                  width: 200,
                  child:
                      /* Continue Button */
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: ((context) => const LoginView()))),
                          child: const Text(
                            "Continuar",
                          )))
            ],
          )),
        ),
      );
}
