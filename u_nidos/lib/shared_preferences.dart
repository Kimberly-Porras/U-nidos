import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const _keyUniversidad = 'universidad';
  static const _keyUid = 'uid';
  static const _keyCampus = 'campus';

  // ==============================
  // UNIVERSIDAD
  // ==============================

  /// Guarda la universidad seleccionada
  static Future<void> guardarUniversidad(String universidad) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUniversidad, universidad);
  }

  /// Obtiene la universidad seleccionada, o null si no está guardada
  static Future<String?> obtenerUniversidad() async {
    final prefs = await SharedPreferences.getInstance();
    final universidad = prefs.getString(_keyUniversidad);
    print('🧪 Campus obtenido de SharedPrefs: $universidad');

    return universidad?.isNotEmpty == true ? universidad : null;
  }

  /// Elimina la universidad guardada
  static Future<void> borrarUniversidad() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUniversidad);
  }

  // ==============================
  // CAMPUS (para filtrar publicaciones)
  // ==============================

  /// Guarda el campus seleccionado (ej. 'Campus Omar Dengo (Heredia)')
  static Future<void> guardarCampus(String campus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCampus, campus);
  }

  /// Obtiene el campus guardado
  static Future<String?> obtenerCampus() async {
    final prefs = await SharedPreferences.getInstance();
    final campus = prefs.getString(_keyCampus);
    print('🧪 Campus obtenido de SharedPrefs: $campus'); // ✅ CORRECTO
    return campus?.isNotEmpty == true ? campus : null;
  }

  /// Elimina el campus guardado
  static Future<void> borrarCampus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCampus);
  }

  // ==============================
  // UID DEL USUARIO
  // ==============================

  /// Guarda el UID del usuario después del login
  static Future<void> guardarUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUid, uid);
  }

  /// Obtiene el UID del usuario, o una cadena vacía si no existe
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
