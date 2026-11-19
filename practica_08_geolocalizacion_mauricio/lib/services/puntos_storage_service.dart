import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/punto_interes.dart';

class PuntosStorageService {
  static const String _clavePuntos = 'puntos_interes';

  Future<void> guardarPuntos(List<PuntoInteres> puntos) async {
    final preferencias = await SharedPreferences.getInstance();

    final datos = puntos.map((punto) => punto.toMap()).toList();

    await preferencias.setString(_clavePuntos, jsonEncode(datos));
  }

  Future<List<PuntoInteres>> cargarPuntos() async {
    final preferencias = await SharedPreferences.getInstance();

    final contenido = preferencias.getString(_clavePuntos);

    if (contenido == null || contenido.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> datos = jsonDecode(contenido);

      return datos.map((elemento) {
        return PuntoInteres.fromMap(Map<String, dynamic>.from(elemento));
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> eliminarTodos() async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.remove(_clavePuntos);
  }
}
