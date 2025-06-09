import 'package:flutter/material.dart';

class AppColors {
  static final Map<String, Color> coloresUniversidades = {
    'UNA': Color(0xFFAD002E),
    'UCR': Color(0xFF007DC5),
    'TEC': Color(0xFF0C2340),
    'UNED': Color(0xFF003366),
    'UTN': Color(0xFF003865),
  };

  static Color obtenerColor(String universidad) {
    return coloresUniversidades[universidad] ?? Colors.grey;
  }
}
