class Incidencia {
  const Incidencia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.fecha,
    this.fotoPath,
    this.latitud,
    this.longitud,
  });

  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final DateTime fecha;
  final String? fotoPath;
  final double? latitud;
  final double? longitud;

  String get fechaTexto =>
      '${fecha.day.toString().padLeft(2, '0')}/'
      '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

  String get horaTexto =>
      '${fecha.hour.toString().padLeft(2, '0')}:'
      '${fecha.minute.toString().padLeft(2, '0')}';

  String get ubicacionTexto {
    if (latitud == null || longitud == null) return 'Sin ubicación';
    return '${latitud!.toStringAsFixed(6)}, ${longitud!.toStringAsFixed(6)}';
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'categoria': categoria,
    'fecha': fecha.toIso8601String(),
    'fotoPath': fotoPath,
    'latitud': latitud,
    'longitud': longitud,
  };

  factory Incidencia.fromMap(Map<String, dynamic> map) => Incidencia(
    id: map['id'] as String,
    titulo: map['titulo'] as String,
    descripcion: map['descripcion'] as String,
    categoria: map['categoria'] as String,
    fecha: DateTime.parse(map['fecha'] as String),
    fotoPath: map['fotoPath'] as String?,
    latitud: (map['latitud'] as num?)?.toDouble(),
    longitud: (map['longitud'] as num?)?.toDouble(),
  );
}
