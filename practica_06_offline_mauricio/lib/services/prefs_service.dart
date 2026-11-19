import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _keyNombre = 'nombre_usuario';
  static const _keyFiltro = 'filtro_tareas';

  static Future<void> guardarNombre(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNombre, nombre);
  }

  static Future<String> leerNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNombre) ?? 'Invitado';
  }

  static Future<void> guardarFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFiltro, filtro);
  }

  static Future<String> leerFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFiltro) ?? 'Todas';
  }
}
