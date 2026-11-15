class Lugar {
  final String id;
  final String nombre;
  final double latitud;
  final double longitud;
  final DateTime creado;

  const Lugar({
    required this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.creado,
  });

  String get coordenadas =>
      '${latitud.toStringAsFixed(6)}, ${longitud.toStringAsFixed(6)}';

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'latitud': latitud,
    'longitud': longitud,
    'creado': creado.toIso8601String(),
  };

  factory Lugar.fromJson(Map<String, dynamic> j) => Lugar(
    id: j['id'] as String,
    nombre: j['nombre'] as String,
    latitud: (j['latitud'] as num).toDouble(),
    longitud: (j['longitud'] as num).toDouble(),
    creado: DateTime.parse(j['creado'] as String),
  );
}
