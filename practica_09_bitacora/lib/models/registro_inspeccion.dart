import '../services/sensores_service.dart';

String _dos(int n) => n.toString().padLeft(2, '0');

class RegistroInspeccion {
  const RegistroInspeccion({
    required this.rutaFoto,
    required this.fecha,
    required this.acelerometro,
    required this.giroscopio,
  });

  factory RegistroInspeccion.fromMap(Map<String, dynamic> mapa) {
    return RegistroInspeccion(
      rutaFoto: mapa['rutaFoto'] as String,
      fecha: DateTime.fromMillisecondsSinceEpoch(mapa['fecha'] as int),
      acelerometro: _mapaALectura(mapa['acelerometro']),
      giroscopio: _mapaALectura(mapa['giroscopio']),
    );
  }

  final String rutaFoto;
  final DateTime fecha;
  final LecturaSensor? acelerometro;
  final LecturaSensor? giroscopio;

  Map<String, dynamic> toMap() {
    return {
      'rutaFoto': rutaFoto,
      'fecha': fecha.millisecondsSinceEpoch,
      'acelerometro': _lecturaAMapa(acelerometro),
      'giroscopio': _lecturaAMapa(giroscopio),
    };
  }

  String get fechaTexto =>
      '${_dos(fecha.day)}/${_dos(fecha.month)}/${fecha.year}';

  String get horaTexto =>
      '${_dos(fecha.hour)}:${_dos(fecha.minute)}:${_dos(fecha.second)}';

  String get acelerometroTexto => textoLectura(acelerometro);

  String get giroscopioTexto => textoLectura(giroscopio);

  static String textoLectura(LecturaSensor? lectura) {
    if (lectura == null) return 'No disponible';
    return 'X: ${lectura.x.toStringAsFixed(2)}  '
        'Y: ${lectura.y.toStringAsFixed(2)}  '
        'Z: ${lectura.z.toStringAsFixed(2)}';
  }

  static Map<String, double>? _lecturaAMapa(LecturaSensor? lectura) {
    if (lectura == null) return null;
    return {'x': lectura.x, 'y': lectura.y, 'z': lectura.z};
  }

  static LecturaSensor? _mapaALectura(Object? dato) {
    if (dato is! Map) return null;
    return LecturaSensor(
      (dato['x'] as num).toDouble(),
      (dato['y'] as num).toDouble(),
      (dato['z'] as num).toDouble(),
    );
  }
}
