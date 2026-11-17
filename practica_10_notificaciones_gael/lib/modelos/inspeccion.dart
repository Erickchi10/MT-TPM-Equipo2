
class Inspeccion {
  final int? id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String? fotoPath;
  final double? latitud;
  final double? longitud;
  final String fecha;

  final double? acelerometroX;
  final double? acelerometroY;
  final double? acelerometroZ;

  final double? giroscopioX;
  final double? giroscopioY;
  final double? giroscopioZ;

  final bool sincronizado;

  Inspeccion({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    this.fotoPath,
    this.latitud,
    this.longitud,
    required this.fecha,
    this.acelerometroX,
    this.acelerometroY,
    this.acelerometroZ,
    this.giroscopioX,
    this.giroscopioY,
    this.giroscopioZ,
    this.sincronizado = false,
  });

  Map<String, Object?> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'foto_path': fotoPath,
      'latitud': latitud,
      'longitud': longitud,
      'fecha': fecha,
      'acelerometro_x': acelerometroX,
      'acelerometro_y': acelerometroY,
      'acelerometro_z': acelerometroZ,
      'giroscopio_x': giroscopioX,
      'giroscopio_y': giroscopioY,
      'giroscopio_z': giroscopioZ,
      'sincronizado': sincronizado ? 1 : 0,
    };
  }

  factory Inspeccion.fromMap(Map<String, Object?> map) {
    return Inspeccion(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descripcion: map['descripcion'] as String,
      categoria: map['categoria'] as String,
      fotoPath: map['foto_path'] as String?,
      latitud: (map['latitud'] as num?)?.toDouble(),
      longitud: (map['longitud'] as num?)?.toDouble(),
      fecha: map['fecha'] as String,
      acelerometroX:
          (map['acelerometro_x'] as num?)?.toDouble(),
      acelerometroY:
          (map['acelerometro_y'] as num?)?.toDouble(),
      acelerometroZ:
          (map['acelerometro_z'] as num?)?.toDouble(),
      giroscopioX:
          (map['giroscopio_x'] as num?)?.toDouble(),
      giroscopioY:
          (map['giroscopio_y'] as num?)?.toDouble(),
      giroscopioZ:
          (map['giroscopio_z'] as num?)?.toDouble(),
      sincronizado: map['sincronizado'] == 1,
    );
  }
}
