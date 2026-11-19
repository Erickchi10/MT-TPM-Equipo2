class PuntoInteres {
  final String nombre;
  final double latitud;
  final double longitud;

  const PuntoInteres({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  // Convertir el punto de interés a un mapa.
  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'latitud': latitud, 'longitud': longitud};
  }

  // Crear un punto de interés desde un mapa.
  factory PuntoInteres.fromMap(Map<String, dynamic> mapa) {
    return PuntoInteres(
      nombre: mapa['nombre'] as String,
      latitud: (mapa['latitud'] as num).toDouble(),
      longitud: (mapa['longitud'] as num).toDouble(),
    );
  }
}
