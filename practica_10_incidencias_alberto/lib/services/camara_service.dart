import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

/// Resultado posible al intentar tomar una foto.
enum EstadoFoto { ok, cancelada, sinPermiso, error }

class ResultadoFoto {
  const ResultadoFoto(this.estado, {this.ruta, this.detalle});

  final EstadoFoto estado;
  final String? ruta;
  final String? detalle;
}

/// Encapsula image_picker. Nunca lanza excepciones: siempre regresa un estado.
class CamaraService {
  CamaraService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<ResultadoFoto> tomarFoto() async {
    try {
      final foto = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1280,
        imageQuality: 80,
      );
      if (foto == null) {
        return const ResultadoFoto(EstadoFoto.cancelada);
      }
      return ResultadoFoto(EstadoFoto.ok, ruta: foto.path);
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied' ||
          e.code == 'camera_access_restricted') {
        return const ResultadoFoto(EstadoFoto.sinPermiso);
      }
      return ResultadoFoto(EstadoFoto.error, detalle: e.message ?? e.code);
    } catch (e) {
      return ResultadoFoto(EstadoFoto.error, detalle: '$e');
    }
  }
}
