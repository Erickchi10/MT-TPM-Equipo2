import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/incidencia.dart';

class IncidenciasRepositorio {
  static const _clave = 'incidencias_alberto';

  Future<List<Incidencia>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_clave);
    if (texto == null) return [];
    try {
      final lista = jsonDecode(texto) as List;
      return lista
          .map((e) => Incidencia.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> guardar(List<Incidencia> lista) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _clave,
      jsonEncode(lista.map((i) => i.toJson()).toList()),
    );
  }
}
