/// Aviso que llega de la API REST (JSONPlaceholder /posts).
class Aviso {
  const Aviso({required this.id, required this.titulo, required this.cuerpo});

  final int id;
  final String titulo;
  final String cuerpo;

  factory Aviso.fromJson(Map<String, dynamic> j) => Aviso(
    id: j['id'] as int,
    titulo: j['title'] as String,
    cuerpo: j['body'] as String,
  );
}
