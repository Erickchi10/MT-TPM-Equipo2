import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/objeto.dart';
import '../models/resguardante.dart';

/// Guarda los objetos y la última lista de personal descargada,
/// para que la app funcione sin internet.
class ObjetosRepositorio {
  static const _claveObjetos = 'objetos_alberto';
  static const _claveResguardantes = 'resguardantes_alberto';

  Future<List<Objeto>> cargar() => _leer(_claveObjetos, Objeto.fromJson);

  Future<void> guardar(List<Objeto> lista) =>
      _escribir(_claveObjetos, lista.map((o) => o.toJson()).toList());

  Future<List<Resguardante>> cargarResguardantes() =>
      _leer(_claveResguardantes, Resguardante.fromJson);

  Future<void> guardarResguardantes(List<Resguardante> lista) =>
      _escribir(_claveResguardantes, lista.map((r) => r.toJson()).toList());

  Future<List<T>> _leer<T>(
    String clave,
    T Function(Map<String, dynamic>) desde,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(clave);
    if (texto == null) return [];
    try {
      final lista = jsonDecode(texto) as List;
      return lista.map((e) => desde(e as Map<String, dynamic>)).toList();
    } catch (_) {
      // Datos dañados: se empieza con la lista vacía.
      return [];
    }
  }

  Future<void> _escribir(String clave, List<Map<String, dynamic>> datos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(clave, jsonEncode(datos));
  }
}
