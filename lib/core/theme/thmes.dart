import 'package:flutter/material.dart';

ThemeData themeDark = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(primary: Colors.grey.shade700,secondary: Colors.grey.shade900,background: Colors.grey.shade900)
);
ThemeData themeLight = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(primary: Colors.grey.shade300,secondary: Colors.grey.shade200,background: Colors.grey.shade400)
);