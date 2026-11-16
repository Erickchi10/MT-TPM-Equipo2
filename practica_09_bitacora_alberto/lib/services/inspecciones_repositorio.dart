import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/inspeccion.dart';

class InspeccionesRepositorio {
  static const _clave = 'inspecciones_alberto';

  Future<List<Inspeccion>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_clave);
    if (texto == null) return [];
    try {
      final lista = jsonDecode(texto) as List;
      return lista
          .map((e) => Inspeccion.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Si los datos están dañados se empieza con la bitácora vacía.
      return [];
    }
  }

  Future<void> guardar(List<Inspeccion> lista) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _clave,
      jsonEncode(lista.map((i) => i.toJson()).toList()),
    );
  }
}
