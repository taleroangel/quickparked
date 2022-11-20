import 'package:flutter/material.dart';

class QuickParkedLogo extends StatelessWidget {
  const QuickParkedLogo({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Image.asset(
            'assets/images/quickparked.png',
            width: 120,
          ),
          Text(
            "QuickParked",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w500,
                height: 2),
          ),
        ],
      );
}
