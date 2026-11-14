enum Prioridad { alta, media, baja }

extension PrioridadTexto on Prioridad {
  String get etiqueta => switch (this) {
    Prioridad.alta => 'Alta',
    Prioridad.media => 'Media',
    Prioridad.baja => 'Baja',
  };
}

class Tarea {
  final int? id;
  final String titulo;
  final String descripcion;
  final Prioridad prioridad;
  final bool completada;
  final DateTime creada;
  final bool pendienteSincronizar;

  const Tarea({
    this.id,
    required this.titulo,
    this.descripcion = '',
    this.prioridad = Prioridad.media,
    this.completada = false,
    required this.creada,
    this.pendienteSincronizar = true,
  });

  // Cualquier cambio local deja la tarea pendiente de enviar al servidor.
  Tarea copyWith({
    String? titulo,
    String? descripcion,
    Prioridad? prioridad,
    bool? completada,
  }) => Tarea(
    id: id,
    titulo: titulo ?? this.titulo,
    descripcion: descripcion ?? this.descripcion,
    prioridad: prioridad ?? this.prioridad,
    completada: completada ?? this.completada,
    creada: creada,
    pendienteSincronizar: true,
  );

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'prioridad': prioridad.index,
    'completada': completada ? 1 : 0,
    'creada': creada.millisecondsSinceEpoch,
    'pendiente_sincronizar': pendienteSincronizar ? 1 : 0,
  };

  factory Tarea.fromMap(Map<String, Object?> m) => Tarea(
    id: m['id'] as int?,
    titulo: m['titulo'] as String,
    descripcion: (m['descripcion'] as String?) ?? '',
    prioridad: Prioridad.values[m['prioridad'] as int],
    completada: m['completada'] == 1,
    creada: DateTime.fromMillisecondsSinceEpoch(m['creada'] as int),
    pendienteSincronizar: m['pendiente_sincronizar'] == 1,
  );

  static String? validarTitulo(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'El título es obligatorio';
    if (texto.length < 3) return 'Mínimo 3 caracteres';
    if (texto.length > 60) return 'Máximo 60 caracteres';
    return null;
  }
}
