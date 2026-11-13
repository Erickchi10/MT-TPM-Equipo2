enum EstadoOrden { pendiente, enProceso, terminada }

extension EstadoOrdenTexto on EstadoOrden {
  String get texto {
    switch (this) {
      case EstadoOrden.pendiente:
        return 'Pendiente';
      case EstadoOrden.enProceso:
        return 'En proceso';
      case EstadoOrden.terminada:
        return 'Terminada';
    }
  }
}

class Orden {
  const Orden({
    required this.id,
    required this.equipo,
    required this.descripcion,
    required this.prioridad,
    required this.tecnico,
    required this.fecha,
    this.estado = EstadoOrden.pendiente,
    this.fotoPath,
  });

  final String id;
  final String equipo;
  final String descripcion;
  final String prioridad;
  final String tecnico;
  final DateTime fecha;
  final EstadoOrden estado;
  final String? fotoPath;

  String get fechaTexto =>
      '${fecha.day.toString().padLeft(2, '0')}/'
      '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

  String get horaTexto =>
      '${fecha.hour.toString().padLeft(2, '0')}:'
      '${fecha.minute.toString().padLeft(2, '0')}';

  Orden copiarCon({EstadoOrden? estado}) => Orden(
    id: id,
    equipo: equipo,
    descripcion: descripcion,
    prioridad: prioridad,
    tecnico: tecnico,
    fecha: fecha,
    estado: estado ?? this.estado,
    fotoPath: fotoPath,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'equipo': equipo,
    'descripcion': descripcion,
    'prioridad': prioridad,
    'tecnico': tecnico,
    'fecha': fecha.toIso8601String(),
    'estado': estado.name,
    'fotoPath': fotoPath,
  };

  factory Orden.fromMap(Map<String, dynamic> map) => Orden(
    id: map['id'] as String,
    equipo: map['equipo'] as String,
    descripcion: map['descripcion'] as String,
    prioridad: map['prioridad'] as String,
    tecnico: map['tecnico'] as String,
    fecha: DateTime.parse(map['fecha'] as String),
    estado: EstadoOrden.values.firstWhere(
      (e) => e.name == map['estado'],
      orElse: () => EstadoOrden.pendiente,
    ),
    fotoPath: map['fotoPath'] as String?,
  );
}
