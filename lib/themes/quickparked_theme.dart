import 'package:flutter/material.dart';

abstract class QuickParkedColors {
  static const quickparked = Color(0xff098ec5);
  static const secondary = Color(0xffb5deff);
}

final ThemeData quickParkedThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: QuickParkedColors.quickparked,
  disabledColor: QuickParkedColors.secondary,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: QuickParkedColors.quickparked,
          foregroundColor: Colors.white)),
);
