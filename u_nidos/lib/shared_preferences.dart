import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const _keyUniversidad = 'universidad';
  static const _keyUid = 'uid';

  // ==============================
  // UNIVERSIDAD
  // ==============================

  /// Guarda la universidad seleccionada en preferencias
  static Future<void> guardarUniversidad(String universidad) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUniversidad, universidad);
  }

  /// Obtiene la universidad guardada, o null si no existe
  static Future<String?> obtenerUniversidad() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUniversidad);
  }

  /// Elimina la universidad guardada
  static Future<void> borrarUniversidad() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUniversidad);
  }

  // ==============================
  // UID DEL USUARIO
  // ==============================

  /// Guarda el UID del usuario después del login
  static Future<void> guardarUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUid, uid);
  }

  /// Obtiene el UID guardado, o una cadena vacía si no hay ninguno
  static Future<String> obtenerUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUid) ?? '';
  }

  /// Elimina el UID (por ejemplo, al cerrar sesión)
  static Future<void> borrarUid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUid);
  }
}
