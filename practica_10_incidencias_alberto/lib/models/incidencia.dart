const categorias = [
  'Infraestructura',
  'Limpieza',
  'Seguridad',
  'Mobiliario',
  'Otro',
];

class Incidencia {
  const Incidencia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.fecha,
    this.fotoRuta,
    this.latitud,
    this.longitud,
  });

  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final DateTime fecha;
  final String? fotoRuta;
  final double? latitud;
  final double? longitud;

  bool get tieneUbicacion => latitud != null && longitud != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'categoria': categoria,
    'fecha': fecha.toIso8601String(),
    'fotoRuta': fotoRuta,
    'latitud': latitud,
    'longitud': longitud,
  };

  factory Incidencia.fromJson(Map<String, dynamic> j) => Incidencia(
    id: j['id'] as String,
    titulo: j['titulo'] as String,
    descripcion: j['descripcion'] as String,
    categoria: j['categoria'] as String,
    fecha: DateTime.parse(j['fecha'] as String),
    fotoRuta: j['fotoRuta'] as String?,
    latitud: (j['latitud'] as num?)?.toDouble(),
    longitud: (j['longitud'] as num?)?.toDouble(),
  );
}
