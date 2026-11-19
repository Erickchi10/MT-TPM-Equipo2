class Reporte {
  final int? id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String? imagenPath;
  final double? latitud;
  final double? longitud;
  final DateTime fecha;
  final bool sincronizado;

  const Reporte({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    this.imagenPath,
    this.latitud,
    this.longitud,
    required this.fecha,
    this.sincronizado = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'imagenPath': imagenPath,
      'latitud': latitud,
      'longitud': longitud,
      'fecha': fecha.toIso8601String(),
      'sincronizado': sincronizado,
    };
  }

  factory Reporte.fromMap(Map<String, dynamic> map) {
    return Reporte(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descripcion: map['descripcion'] as String,
      categoria: map['categoria'] as String,
      imagenPath: map['imagenPath'] as String?,
      latitud: (map['latitud'] as num?)?.toDouble(),
      longitud: (map['longitud'] as num?)?.toDouble(),
      fecha: DateTime.parse(map['fecha'] as String),
      sincronizado: map['sincronizado'] as bool? ?? false,
    );
  }
}
