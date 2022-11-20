import 'package:flutter/material.dart';

abstract class QuickParkedColors {
  static const quickparked = Color(0xFF098ec5);
}

final ThemeData quickParkedThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: QuickParkedColors.quickparked,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: QuickParkedColors.quickparked,
          foregroundColor: Colors.white)),
);
