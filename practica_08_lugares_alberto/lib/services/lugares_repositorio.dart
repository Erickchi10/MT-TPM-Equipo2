import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/lugar.dart';

class LugaresRepositorio {
  static const _clave = 'lugares_alberto';

  Future<List<Lugar>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_clave);
    if (texto == null) return [];
    try {
      final lista = jsonDecode(texto) as List<dynamic>;
      return lista
          .map((e) => Lugar.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return []; // Si los datos están dañados, empieza vacío sin cerrar la app.
    }
  }

  Future<void> guardar(List<Lugar> lugares) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _clave,
      jsonEncode(lugares.map((l) => l.toJson()).toList()),
    );
  }
}
