import 'package:flutter/material.dart';

class FiltroTareas extends StatelessWidget {
  const FiltroTareas({
    super.key,
    required this.filtro,
    required this.onCambiar,
  });

  final String filtro;
  final ValueChanged<String> onCambiar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'todas', label: Text('Todas')),
          ButtonSegment(value: 'pendientes', label: Text('Pendientes')),
          ButtonSegment(value: 'completadas', label: Text('Completadas')),
        ],
        selected: {filtro},
        onSelectionChanged: (seleccion) => onCambiar(seleccion.first),
      ),
    );
  }
}
