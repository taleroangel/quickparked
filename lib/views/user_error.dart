import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class UserError extends StatelessWidget {
  const UserError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Error in user"),
    );
  }
}
