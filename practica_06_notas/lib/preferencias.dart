import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static const _claveNombre = 'nombre_usuario';

  static Future<void> guardarNombre(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveNombre, nombre);
  }

  static Future<String?> leerNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveNombre);
  }
}
