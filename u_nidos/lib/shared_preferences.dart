import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const _keyUniversidad = 'universidad';

  // Guardar la universidad seleccionada
  static Future<void> guardarUniversidad(String universidad) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUniversidad, universidad);
  }

  // Obtener la universidad guardada
  static Future<String?> obtenerUniversidad() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUniversidad);
  }

  // Borrar la universidad (por si el usuario quiere cambiar)
  static Future<void> borrarUniversidad() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUniversidad);
  }
}
