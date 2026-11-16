import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// La cámara deja la foto en una carpeta temporal que Android puede borrar.
/// Por eso se copia a la carpeta de documentos de la app.
class FotosService {
  Future<String> guardar(String rutaTemporal, String id) async {
    final dir = await getApplicationDocumentsDirectory();
    final destino = '${dir.path}${Platform.pathSeparator}inspeccion_$id.jpg';
    await File(rutaTemporal).copy(destino);
    return destino;
  }

  Future<void> borrar(String ruta) async {
    final archivo = File(ruta);
    if (await archivo.exists()) {
      await archivo.delete();
    }
  }
}
