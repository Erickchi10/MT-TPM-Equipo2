class Tarea {
  final int? id;
  final String titulo;
  final bool completada;
  final bool pendienteSincronizar;
  final DateTime fechaCreacion;

  const Tarea({
    this.id,
    required this.titulo,
    this.completada = false,
    this.pendienteSincronizar = true,
    required this.fechaCreacion,
  });

  Tarea copiarCon({
    String? titulo,
    bool? completada,
    bool? pendienteSincronizar,
  }) {
    return Tarea(
      id: id,
      titulo: titulo ?? this.titulo,
      completada: completada ?? this.completada,
      pendienteSincronizar: pendienteSincronizar ?? this.pendienteSincronizar,
      fechaCreacion: fechaCreacion,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'completada': completada ? 1 : 0,
      'pendiente_sincronizar': pendienteSincronizar ? 1 : 0,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }

  factory Tarea.fromMap(Map<String, Object?> map) {
    return Tarea(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      completada: map['completada'] == 1,
      pendienteSincronizar: map['pendiente_sincronizar'] == 1,
      fechaCreacion: DateTime.parse(map['fecha_creacion'] as String),
    );
  }
}
