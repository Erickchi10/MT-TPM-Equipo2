const categorias = ['Electrónicos', 'Ropa', 'Documentos', 'Llaves', 'Otro'];

enum EstadoObjeto {
  encontrado('Encontrado'),
  reclamado('Reclamado'),
  entregado('Entregado');

  const EstadoObjeto(this.etiqueta);
  final String etiqueta;

  /// Estado que sigue en el flujo. Entregado es el último.
  EstadoObjeto? get siguiente => switch (this) {
    EstadoObjeto.encontrado => EstadoObjeto.reclamado,
    EstadoObjeto.reclamado => EstadoObjeto.entregado,
    EstadoObjeto.entregado => null,
  };
}

class Objeto {
  const Objeto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.lugar,
    required this.resguardante,
    required this.fecha,
    this.estado = EstadoObjeto.encontrado,
    this.fotoRuta,
    this.latitud,
    this.longitud,
    this.entregadoA,
    this.fechaEntrega,
  });

  final String id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final String lugar;
  final String resguardante;
  final DateTime fecha;
  final EstadoObjeto estado;
  final String? fotoRuta;
  final double? latitud;
  final double? longitud;
  final String? entregadoA;
  final DateTime? fechaEntrega;

  bool get tieneUbicacion => latitud != null && longitud != null;

  Objeto copyWith({
    EstadoObjeto? estado,
    String? entregadoA,
    DateTime? fechaEntrega,
  }) => Objeto(
    id: id,
    nombre: nombre,
    descripcion: descripcion,
    categoria: categoria,
    lugar: lugar,
    resguardante: resguardante,
    fecha: fecha,
    estado: estado ?? this.estado,
    fotoRuta: fotoRuta,
    latitud: latitud,
    longitud: longitud,
    entregadoA: entregadoA ?? this.entregadoA,
    fechaEntrega: fechaEntrega ?? this.fechaEntrega,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'categoria': categoria,
    'lugar': lugar,
    'resguardante': resguardante,
    'fecha': fecha.toIso8601String(),
    'estado': estado.name,
    'fotoRuta': fotoRuta,
    'latitud': latitud,
    'longitud': longitud,
    'entregadoA': entregadoA,
    'fechaEntrega': fechaEntrega?.toIso8601String(),
  };

  factory Objeto.fromJson(Map<String, dynamic> j) => Objeto(
    id: j['id'] as String,
    nombre: j['nombre'] as String,
    descripcion: j['descripcion'] as String,
    categoria: j['categoria'] as String,
    lugar: j['lugar'] as String,
    resguardante: j['resguardante'] as String,
    fecha: DateTime.parse(j['fecha'] as String),
    estado: EstadoObjeto.values.byName(j['estado'] as String),
    fotoRuta: j['fotoRuta'] as String?,
    latitud: (j['latitud'] as num?)?.toDouble(),
    longitud: (j['longitud'] as num?)?.toDouble(),
    entregadoA: j['entregadoA'] as String?,
    fechaEntrega: j['fechaEntrega'] == null
        ? null
        : DateTime.parse(j['fechaEntrega'] as String),
  );
}
