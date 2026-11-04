class Tarea {
  final int? id;
  final String titulo;
  final bool completada;
  final bool pendienteSincronizar;

  const Tarea({
    this.id,
    required this.titulo,
    this.completada = false,
    this.pendienteSincronizar = true,
  });

  Tarea copiarCon({String? titulo, bool? completada}) => Tarea(
    id: id,
    titulo: titulo ?? this.titulo,
    completada: completada ?? this.completada,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'titulo': titulo,
    'completada': completada ? 1 : 0,
    'pendiente_sincronizar': pendienteSincronizar ? 1 : 0,
  };

  factory Tarea.fromMap(Map<String, Object?> m) => Tarea(
    id: m['id'] as int?,
    titulo: m['titulo'] as String,
    completada: (m['completada'] as int) == 1,
    pendienteSincronizar: (m['pendiente_sincronizar'] as int) == 1,
  );
}
