class Tarea {
  final int? id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final int pendienteSincronizar;

  Tarea({
    this.id,
    required this.titulo,
    required this.descripcion,
    this.completada = false,
    this.pendienteSincronizar = 1, // 1 = pendiente, 0 = sincronizado
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': completada ? 1 : 0,
      'pendiente_sincronizar': pendienteSincronizar,
    };
  }

  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map['id'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      completada: map['completada'] == 1,
      pendienteSincronizar: map['pendiente_sincronizar'] ?? 1,
    );
  }
}
