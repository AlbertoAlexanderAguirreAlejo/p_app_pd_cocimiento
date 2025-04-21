import 'package:flutter/material.dart';

class AppTheme {
  // Colores base
  static const Color blue = Color(0xff3A86FF);
  static const Color purple = Color(0xff8338EC);
  static const Color purpleLight = Color(0xff5038ff);
  static const Color red = Color(0xffFF006E);
  static const Color orange = Color(0xffFB5607);
  static const Color yellow = Color(0xffFFBE0B);
  static const Color green = Color(0xff00cc74);
  static const Color darkGreen = Color(0xff39AA3D);
  static const Color silverBlue = Color(0xff616B8A);
  static const Color dark = Color(0xff252525);
  static const Color bg = Color(0xffECEEF8);
  // static const Color bg = Color(0xffF3F0F4);
  static const Color grey = Color(0xffDBDDE4);
  static const Color shellColor = Color(0xff1D232E);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    // Utilizamos un esquema de color basado en una semilla para Material 3
    colorScheme: ColorScheme.fromSeed(
      seedColor: blue,
      primary: blue,
      secondary: purple,
      surface: bg,
    ),
    scaffoldBackgroundColor: bg,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: blue,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        shape: const StadiumBorder(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      // Cambia el color de los labels (labelText)
      floatingLabelStyle: const TextStyle(color: blue),  // Color del labelText
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: blue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: blue, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: red, width: 2),
      ),
      errorStyle: const TextStyle(color: red),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(blue),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: silverBlue, fontSize: 18),
      bodyLarge: TextStyle(color: silverBlue, fontSize: 18),
      bodyMedium: TextStyle(color: silverBlue, fontSize: 18),
      bodySmall: TextStyle(color: silverBlue, fontSize: 18),
      displayLarge: TextStyle(color: silverBlue, fontSize: 18),
      displayMedium: TextStyle(color: silverBlue, fontSize: 18),
      displaySmall: TextStyle(color: silverBlue, fontSize: 18),
      headlineLarge: TextStyle(color: silverBlue, fontSize: 18),
      headlineMedium: TextStyle(color: silverBlue, fontSize: 18),
      headlineSmall: TextStyle(color: silverBlue, fontSize: 18),
      labelLarge: TextStyle(color: silverBlue, fontSize: 18),
      labelMedium: TextStyle(color: silverBlue, fontSize: 18),
      labelSmall: TextStyle(color: silverBlue, fontSize: 18),
      titleLarge: TextStyle(color: silverBlue, fontSize: 18),
      titleSmall: TextStyle(color: silverBlue, fontSize: 18),
    ),
  );
}
