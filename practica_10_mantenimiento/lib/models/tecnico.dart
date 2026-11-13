class Tecnico {
  const Tecnico({required this.id, required this.nombre, required this.correo});

  final int id;
  final String nombre;
  final String correo;

  factory Tecnico.fromJson(Map<String, dynamic> json) => Tecnico(
    id: json['id'] as int,
    nombre: json['name'] as String,
    correo: json['email'] as String,
  );
}
