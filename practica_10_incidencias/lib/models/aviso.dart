class Aviso {
  const Aviso({required this.id, required this.titulo, required this.texto});

  final int id;
  final String titulo;
  final String texto;

  factory Aviso.fromJson(Map<String, dynamic> json) => Aviso(
    id: json['id'] as int,
    titulo: json['title'] as String,
    texto: json['body'] as String,
  );
}
