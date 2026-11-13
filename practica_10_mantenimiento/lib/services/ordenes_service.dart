import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/orden.dart';

class OrdenesService {
  static const String _clave = 'ordenes_guardadas';

  /// Lee las órdenes guardadas. Si no hay datos o están dañados,
  /// devuelve una lista vacía en lugar de fallar.
  Future<List<Orden>> cargar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final texto = prefs.getString(_clave);
      if (texto == null || texto.isEmpty) return [];
      final lista = jsonDecode(texto) as List<dynamic>;
      return lista
          .map((e) => Orden.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> guardar(List<Orden> ordenes) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(ordenes.map((o) => o.toMap()).toList());
    await prefs.setString(_clave, texto);
  }

  /// Copia la foto temporal a la carpeta de documentos de la app.
  Future<String> copiarFoto(String origen) async {
    final base = await getApplicationDocumentsDirectory();
    final carpeta = Directory('${base.path}/ordenes');
    if (!await carpeta.exists()) {
      await carpeta.create(recursive: true);
    }
    final destino =
        '${carpeta.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(origen).copy(destino);
    return destino;
  }

  Future<void> borrarFoto(String? ruta) async {
    if (ruta == null) return;
    try {
      final archivo = File(ruta);
      if (await archivo.exists()) await archivo.delete();
    } catch (_) {}
  }
}
