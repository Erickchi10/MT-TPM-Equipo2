enum TipoAccion { incremento, decremento, reinicio }

class Registro {
  final TipoAccion tipo;
  final int valorResultante;
  final DateTime fecha;

  const Registro({
    required this.tipo,
    required this.valorResultante,
    required this.fecha,
  });

  String get descripcion => switch (tipo) {
    TipoAccion.incremento => 'Sumó 1',
    TipoAccion.decremento => 'Restó 1',
    TipoAccion.reinicio => 'Reinició',
  };
}
