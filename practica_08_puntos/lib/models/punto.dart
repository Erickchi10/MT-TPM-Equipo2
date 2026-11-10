class Punto {
  final String id;
  final String nombre;
  final double latitud;
  final double longitud;

  const Punto({
    required this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'latitud': latitud,
    'longitud': longitud,
  };

  factory Punto.fromMap(Map<String, dynamic> map) => Punto(
    id: map['id'] as String,
    nombre: map['nombre'] as String,
    latitud: (map['latitud'] as num).toDouble(),
    longitud: (map['longitud'] as num).toDouble(),
  );
}
