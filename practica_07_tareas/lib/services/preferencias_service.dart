import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasService {
  static const _claveFiltro = 'filtro_tareas';

  Future<String> leerFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveFiltro) ?? 'todas';
  }

  Future<void> guardarFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveFiltro, filtro);
  }
}
