import 'package:share_plus/share_plus.dart';

import '../models/publicacion.dart';

class CompartirService {
  static String textoDe(Publicacion p) =>
      '${p.titulo}\n\n${p.cuerpo}\n\n— Publicación #${p.id} (JSONPlaceholder)';

  static Future<void> compartir(Publicacion p) async {
    await SharePlus.instance.share(
      ShareParams(text: textoDe(p), subject: p.titulo),
    );
  }
}
