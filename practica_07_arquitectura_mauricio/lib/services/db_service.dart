import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tarea.dart';

class DbService {
  static const String _key = 'tareas_db_p7';

  static Future<int> insertar(Tarea tarea) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> lista = prefs.getStringList(_key) ?? [];
    final nueva = tarea.toMap()..['id'] = DateTime.now().millisecondsSinceEpoch;
    lista.add(jsonEncode(nueva));
    await prefs.setStringList(_key, lista);
    return 1;
  }

  static Future<List<Tarea>> listar() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> lista = prefs.getStringList(_key) ?? [];
    return lista.map((e) => Tarea.fromMap(jsonDecode(e))).toList();
  }

  static Future<int> actualizar(Tarea tarea) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> lista = prefs.getStringList(_key) ?? [];
    for (int i = 0; i < lista.length; i++) {
      final map = jsonDecode(lista[i]);
      if (map['id'] == tarea.id) {
        lista[i] = jsonEncode(tarea.toMap());
        break;
      }
    }
    await prefs.setStringList(_key, lista);
    return 1;
  }

  static Future<int> eliminar(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> lista = prefs.getStringList(_key) ?? [];
    lista.removeWhere((e) => jsonDecode(e)['id'] == id);
    await prefs.setStringList(_key, lista);
    return 1;
  }
}
