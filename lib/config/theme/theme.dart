import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

ThemeData modoLight = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade200,
    primary: Colors.grey.shade300,
    secondary: Colors.grey.shade400,
    tertiary: Colors.grey.shade100,
    inversePrimary: Colors.grey.shade800,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black,
    fontSize: 18.sp),
    titleLarge: TextStyle(color: Colors.grey.shade800,
    fontWeight: FontWeight.bold, fontSize: 22.sp),
  )
);

ThemeData modoDark = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade600,
    inversePrimary: Colors.grey.shade200,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.white, fontSize: 18.sp),
    titleLarge: TextStyle(
      color: Colors.grey.shade300,
      fontWeight: FontWeight.bold,
      fontSize: 22.sp,
    ),
  )
);