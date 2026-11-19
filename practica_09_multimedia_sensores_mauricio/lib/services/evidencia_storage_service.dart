import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/evidencia.dart';

class EvidenciaStorageService {
  static const String _claveEvidencias = 'evidencias_inspeccion';

  Future<Directory> _obtenerDirectorio() async {
    final directorio = await getApplicationDocumentsDirectory();

    final carpeta = Directory('${directorio.path}/evidencias');

    if (!await carpeta.exists()) {
      await carpeta.create(recursive: true);
    }

    return carpeta;
  }

  Future<List<Evidencia>> cargarEvidencias() async {
    final preferencias = await SharedPreferences.getInstance();

    final datos = preferencias.getString(_claveEvidencias);

    if (datos == null || datos.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> lista = jsonDecode(datos);

      final evidencias = lista
          .map(
            (elemento) =>
                Evidencia.fromMap(Map<String, dynamic>.from(elemento)),
          )
          .where((evidencia) => File(evidencia.imagePath).existsSync())
          .toList();

      return evidencias;
    } catch (error) {
      return [];
    }
  }

  Future<Evidencia> guardarEvidencia(Evidencia evidencia) async {
    final carpeta = await _obtenerDirectorio();

    final archivoOriginal = File(evidencia.imagePath);

    if (!await archivoOriginal.exists()) {
      throw Exception('No se encontró el archivo de imagen.');
    }

    final extension = evidencia.imagePath.contains('.')
        ? evidencia.imagePath.split('.').last
        : 'jpg';

    final nombreArchivo =
        'evidencia_${DateTime.now().microsecondsSinceEpoch}.$extension';

    final nuevaRuta = '${carpeta.path}/$nombreArchivo';

    final archivoGuardado = await archivoOriginal.copy(nuevaRuta);

    final evidenciaGuardada = Evidencia(
      imagePath: archivoGuardado.path,
      fecha: evidencia.fecha,
      acelerometroX: evidencia.acelerometroX,
      acelerometroY: evidencia.acelerometroY,
      acelerometroZ: evidencia.acelerometroZ,
      giroscopioX: evidencia.giroscopioX,
      giroscopioY: evidencia.giroscopioY,
      giroscopioZ: evidencia.giroscopioZ,
    );

    final evidencias = await cargarEvidencias();

    evidencias.insert(0, evidenciaGuardada);

    await _guardarLista(evidencias);

    return evidenciaGuardada;
  }

  Future<void> eliminarEvidencia(Evidencia evidencia) async {
    final evidencias = await cargarEvidencias();

    evidencias.removeWhere(
      (elemento) => elemento.imagePath == evidencia.imagePath,
    );

    await _guardarLista(evidencias);

    final archivo = File(evidencia.imagePath);

    if (await archivo.exists()) {
      await archivo.delete();
    }
  }

  Future<void> _guardarLista(List<Evidencia> evidencias) async {
    final preferencias = await SharedPreferences.getInstance();

    final datos = jsonEncode(
      evidencias.map((evidencia) => evidencia.toMap()).toList(),
    );

    await preferencias.setString(_claveEvidencias, datos);
  }
}
