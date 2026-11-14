import 'package:shared_preferences/shared_preferences.dart';

import '../models/orden.dart';

class PreferenciasUI {
  static const _claveCompletadas = 'mostrar_completadas';
  static const _claveOrden = 'orden_tareas';

  static Future<bool> leerMostrarCompletadas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveCompletadas) ?? true;
  }

  static Future<void> guardarMostrarCompletadas(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_claveCompletadas, valor);
  }

  static Future<OrdenTareas> leerOrden() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre = prefs.getString(_claveOrden);
    return OrdenTareas.values.firstWhere(
      (o) => o.name == nombre,
      orElse: () => OrdenTareas.prioridad,
    );
  }

  static Future<void> guardarOrden(OrdenTareas orden) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveOrden, orden.name);
  }
}
