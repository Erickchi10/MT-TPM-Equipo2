import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum EstadoCamara { ok, cancelado, permisoDenegado, error }

class RespuestaCamara {
  const RespuestaCamara(this.estado, [this.imagen]);

  final EstadoCamara estado;
  final XFile? imagen;
}

class CamaraService {
  final ImagePicker _picker = ImagePicker();

  Future<RespuestaCamara> tomarFoto() async {
    try {
      final foto = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1280,
      );
      if (foto == null) {
        return const RespuestaCamara(EstadoCamara.cancelado);
      }
      return RespuestaCamara(EstadoCamara.ok, foto);
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied' ||
          e.code == 'camera_access_restricted') {
        return const RespuestaCamara(EstadoCamara.permisoDenegado);
      }
      return const RespuestaCamara(EstadoCamara.error);
    } catch (_) {
      return const RespuestaCamara(EstadoCamara.error);
    }
  }
}
