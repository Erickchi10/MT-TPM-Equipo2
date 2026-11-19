import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/reporte.dart';

class ReporteStorageService {
  static const String _claveReportes = 'reportes_guardados';

  Future<Directory> _obtenerDirectorioEvidencias() async {
    final directorioDocumentos = await getApplicationDocumentsDirectory();

    final directorioEvidencias = Directory(
      '${directorioDocumentos.path}/evidencias',
    );

    if (!await directorioEvidencias.exists()) {
      await directorioEvidencias.create(recursive: true);
    }

    return directorioEvidencias;
  }

  Future<Reporte> guardarReporte(Reporte reporte) async {
    final preferencias = await SharedPreferences.getInstance();
    final reportesActuales = await obtenerReportes();

    String? nuevaRutaImagen;

    // Copiar la fotografía al almacenamiento permanente.
    if (reporte.imagenPath != null) {
      final archivoOriginal = File(reporte.imagenPath!);

      if (await archivoOriginal.exists()) {
        final directorio = await _obtenerDirectorioEvidencias();

        final extension = reporte.imagenPath!.contains('.')
            ? '.${reporte.imagenPath!.split('.').last}'
            : '.jpg';

        final nombreArchivo =
            'evidencia_${DateTime.now().microsecondsSinceEpoch}$extension';

        final nuevaRuta = '${directorio.path}/$nombreArchivo';
        final archivoCopiado = await archivoOriginal.copy(nuevaRuta);

        nuevaRutaImagen = archivoCopiado.path;
      } else {
        throw Exception('No se encontró el archivo de fotografía.');
      }
    }

    final nuevoReporte = Reporte(
      id: DateTime.now().microsecondsSinceEpoch,
      titulo: reporte.titulo,
      descripcion: reporte.descripcion,
      categoria: reporte.categoria,
      imagenPath: nuevaRutaImagen,
      latitud: reporte.latitud,
      longitud: reporte.longitud,
      fecha: reporte.fecha,
      sincronizado: false,
    );

    reportesActuales.add(nuevoReporte);

    final datosJson = jsonEncode(
      reportesActuales.map((elemento) => elemento.toMap()).toList(),
    );

    final guardado = await preferencias.setString(_claveReportes, datosJson);

    if (!guardado) {
      if (nuevaRutaImagen != null) {
        final archivo = File(nuevaRutaImagen);

        if (await archivo.exists()) {
          await archivo.delete();
        }
      }

      throw Exception('No se pudo guardar el reporte.');
    }

    return nuevoReporte;
  }

  Future<List<Reporte>> obtenerReportes() async {
    final preferencias = await SharedPreferences.getInstance();
    final datos = preferencias.getString(_claveReportes);

    if (datos == null || datos.isEmpty) {
      return [];
    }

    final List<dynamic> listaJson = jsonDecode(datos);

    return listaJson.map((elemento) {
      return Reporte.fromMap(Map<String, dynamic>.from(elemento));
    }).toList();
  }

  Future<void> marcarComoSincronizado(int id) async {
    final preferencias = await SharedPreferences.getInstance();
    final reportesActuales = await obtenerReportes();

    final indice = reportesActuales.indexWhere((reporte) => reporte.id == id);

    if (indice == -1) {
      throw Exception('No se encontró el reporte seleccionado.');
    }

    final reporte = reportesActuales[indice];

    final reporteActualizado = Reporte(
      id: reporte.id,
      titulo: reporte.titulo,
      descripcion: reporte.descripcion,
      categoria: reporte.categoria,
      imagenPath: reporte.imagenPath,
      latitud: reporte.latitud,
      longitud: reporte.longitud,
      fecha: reporte.fecha,
      sincronizado: true,
    );

    reportesActuales[indice] = reporteActualizado;

    final datosJson = jsonEncode(
      reportesActuales.map((elemento) => elemento.toMap()).toList(),
    );

    final guardado = await preferencias.setString(_claveReportes, datosJson);

    if (!guardado) {
      throw Exception('No se pudo actualizar el estado de sincronización.');
    }
  }

  Future<void> eliminarReporte(int id) async {
    final preferencias = await SharedPreferences.getInstance();
    final reportesActuales = await obtenerReportes();

    final indice = reportesActuales.indexWhere((elemento) => elemento.id == id);

    if (indice == -1) {
      throw Exception('No se encontró el reporte que deseas eliminar.');
    }

    final reporte = reportesActuales[indice];

    // Eliminar la fotografía almacenada.
    if (reporte.imagenPath != null) {
      final archivo = File(reporte.imagenPath!);

      if (await archivo.exists()) {
        await archivo.delete();
      }
    }

    reportesActuales.removeAt(indice);

    final datosJson = jsonEncode(
      reportesActuales.map((elemento) => elemento.toMap()).toList(),
    );

    final guardado = await preferencias.setString(_claveReportes, datosJson);

    if (!guardado) {
      throw Exception('No se pudo eliminar el reporte.');
    }
  }
}
