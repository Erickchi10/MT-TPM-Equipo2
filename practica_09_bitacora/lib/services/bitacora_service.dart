import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/registro_inspeccion.dart';

class BitacoraService {
  static const String _clave = 'bitacora_inspecciones';

  Future<List<RegistroInspeccion>> cargar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final texto = prefs.getString(_clave);
      if (texto == null) return [];
      final lista = jsonDecode(texto) as List<dynamic>;
      return lista
          .map((e) => RegistroInspeccion.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> guardar(List<RegistroInspeccion> registros) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(registros.map((r) => r.toMap()).toList());
    await prefs.setString(_clave, texto);
  }

  Future<String> copiarFoto(String rutaOrigen) async {
    try {
      final base = await getApplicationDocumentsDirectory();
      final carpeta = Directory(
        '${base.path}${Platform.pathSeparator}bitacora',
      );
      if (!await carpeta.exists()) {
        await carpeta.create(recursive: true);
      }
      final destino =
          '${carpeta.path}${Platform.pathSeparator}'
          'inspeccion_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(rutaOrigen).copy(destino);
      return destino;
    } catch (_) {
      return rutaOrigen;
    }
  }

  Future<void> borrarFoto(String ruta) async {
    try {
      final archivo = File(ruta);
      if (await archivo.exists()) {
        await archivo.delete();
      }
    } catch (_) {
      // Si no se puede borrar el archivo, la bitácora sigue funcionando.
    }
  }
}
