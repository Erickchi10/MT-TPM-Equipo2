import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/incidencia.dart';

class IncidenciasService {
  static const String _clave = 'incidencias_guardadas';

  /// Lee los reportes guardados. Si no hay datos o están dañados,
  /// devuelve una lista vacía en lugar de fallar.
  Future<List<Incidencia>> cargar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final texto = prefs.getString(_clave);
      if (texto == null || texto.isEmpty) return [];
      final lista = jsonDecode(texto) as List<dynamic>;
      return lista
          .map((e) => Incidencia.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> guardar(List<Incidencia> incidencias) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(incidencias.map((i) => i.toMap()).toList());
    await prefs.setString(_clave, texto);
  }

  /// Copia la foto temporal a la carpeta de documentos de la app
  /// para que no se pierda al cerrarla.
  Future<String> copiarFoto(String origen) async {
    final base = await getApplicationDocumentsDirectory();
    final carpeta = Directory('${base.path}/incidencias');
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
