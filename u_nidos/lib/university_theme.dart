import 'package:flutter/material.dart';

final Map<String, Color> coloresUniversidades = {
  'UNA': Color(0xFFAD002E),
  'UCR': Color(0xFF007DC5),
  'TEC': Color(0xFF0C2340),
  'UNED': Color(0xFF003366),
  'UTN': Color(0xFF003865),
};

/// Devuelve un tema basado en la universidad seleccionada.
ThemeData obtenerTemaPorUniversidad(String universidad) {
  final colorPrincipal = coloresUniversidades[universidad] ?? Colors.blue;

  return ThemeData(
    primaryColor: colorPrincipal,
    colorScheme: ColorScheme.fromSeed(seedColor: colorPrincipal),
    appBarTheme: AppBarTheme(
      backgroundColor: colorPrincipal,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorPrincipal,
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorPrincipal,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
