import 'package:flutter/material.dart';
import 'package:quick_parked/themes/quick_parked_theme.dart';
import 'package:quick_parked/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
      theme: quickParkedThemeData,
      title: 'QuickParked',
      home: const HomeView());
}
