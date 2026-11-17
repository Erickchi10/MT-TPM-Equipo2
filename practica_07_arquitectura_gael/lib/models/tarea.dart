class Tarea {
  const Tarea({
    required this.id,
    required this.titulo,
    required this.creada,
    this.completada = false,
  });

  final String id;
  final String titulo;
  final DateTime creada;
  final bool completada;

  Tarea copyWith({String? titulo, bool? completada}) {
    return Tarea(
      id: id,
      titulo: titulo ?? this.titulo,
      creada: creada,
      completada: completada ?? this.completada,
    );
  }
}
