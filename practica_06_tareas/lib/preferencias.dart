import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static const _claveFiltro = 'filtro_tareas';

  static Future<void> guardarFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveFiltro, filtro);
  }

  static Future<String> leerFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveFiltro) ?? 'todas';
  }
}
