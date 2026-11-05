class Nota {
  final int? id;
  final String titulo;
  final String contenido;
  final bool pendienteSincronizar;

  const Nota({
    this.id,
    required this.titulo,
    required this.contenido,
    this.pendienteSincronizar = true,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'titulo': titulo,
    'contenido': contenido,
    'pendiente_sincronizar': pendienteSincronizar ? 1 : 0,
  };

  factory Nota.fromMap(Map<String, Object?> m) => Nota(
    id: m['id'] as int?,
    titulo: m['titulo'] as String,
    contenido: m['contenido'] as String,
    pendienteSincronizar: (m['pendiente_sincronizar'] as int) == 1,
  );
}
