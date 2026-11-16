/// Persona del ITESCAM que resguarda el objeto (viene de la API /users).
class Resguardante {
  const Resguardante({
    required this.id,
    required this.nombre,
    required this.correo,
  });

  final int id;
  final String nombre;
  final String correo;

  factory Resguardante.fromJson(Map<String, dynamic> j) => Resguardante(
    id: j['id'] as int,
    nombre: j['name'] as String,
    correo: j['email'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': nombre, 'email': correo};
}
