import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/punto.dart';

/// Guarda y carga la lista de puntos de interés en el dispositivo.
class PuntosService {
  static const _clave = 'puntos_interes';

  Future<List<Punto>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_clave);
    if (texto == null) return [];
    try {
      final lista = jsonDecode(texto) as List<dynamic>;
      return lista
          .map((e) => Punto.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> guardar(List<Punto> puntos) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(puntos.map((p) => p.toMap()).toList());
    await prefs.setString(_clave, texto);
  }
}
