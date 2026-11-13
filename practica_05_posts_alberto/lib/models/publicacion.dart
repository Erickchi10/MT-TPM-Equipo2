class Publicacion {
  final int id;
  final int usuarioId;
  final String titulo;
  final String cuerpo;

  const Publicacion({
    required this.id,
    required this.usuarioId,
    required this.titulo,
    required this.cuerpo,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) => Publicacion(
    id: json['id'] as int,
    usuarioId: json['userId'] as int,
    titulo: json['title'] as String,
    cuerpo: json['body'] as String,
  );
}
