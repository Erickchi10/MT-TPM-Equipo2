class Habito {
  final int id;
  final String nombre;
  final bool completado;

  const Habito({
    required this.id,
    required this.nombre,
    this.completado = false,
  });

  Habito copiarCon({String? nombre, bool? completado}) {
    return Habito(
      id: id,
      nombre: nombre ?? this.nombre,
      completado: completado ?? this.completado,
    );
  }
}
