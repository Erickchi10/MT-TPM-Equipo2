import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Copia la foto temporal de la cámara a la carpeta de la app.
class FotosService {
  Future<String> guardar(String rutaTemporal, String nombre) async {
    final dir = await getApplicationDocumentsDirectory();
    final destino = '${dir.path}${Platform.pathSeparator}$nombre.jpg';
    await File(rutaTemporal).copy(destino);
    return destino;
  }
}
