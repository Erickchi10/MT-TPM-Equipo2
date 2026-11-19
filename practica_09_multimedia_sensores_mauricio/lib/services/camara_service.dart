import 'package:image_picker/image_picker.dart';

class CamaraService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> tomarFotografia() async {
    return await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
  }

  Future<XFile?> seleccionarGaleria() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
  }
}
