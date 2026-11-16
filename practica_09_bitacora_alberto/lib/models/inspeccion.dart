import '../services/sensores_service.dart';

class Inspeccion {
  const Inspeccion({
    required this.id,
    required this.titulo,
    required this.fotoRuta,
    required this.fecha,
    this.acelerometro,
    this.giroscopio,
  });

  final String id;
  final String titulo;
  final String fotoRuta;
  final DateTime fecha;

  /// null cuando el sensor no estaba disponible.
  final Lectura? acelerometro;
  final Lectura? giroscopio;

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'fotoRuta': fotoRuta,
    'fecha': fecha.toIso8601String(),
    'acelerometro': _aJson(acelerometro),
    'giroscopio': _aJson(giroscopio),
  };

  factory Inspeccion.fromJson(Map<String, dynamic> j) => Inspeccion(
    id: j['id'] as String,
    titulo: j['titulo'] as String,
    fotoRuta: j['fotoRuta'] as String,
    fecha: DateTime.parse(j['fecha'] as String),
    acelerometro: _deJson(j['acelerometro']),
    giroscopio: _deJson(j['giroscopio']),
  );

  static Map<String, double>? _aJson(Lectura? l) =>
      l == null ? null : {'x': l.x, 'y': l.y, 'z': l.z};

  static Lectura? _deJson(Object? o) {
    if (o is! Map) return null;
    return (
      x: (o['x'] as num).toDouble(),
      y: (o['y'] as num).toDouble(),
      z: (o['z'] as num).toDouble(),
    );
  }
}
