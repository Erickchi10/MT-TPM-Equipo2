import 'package:flutter/material.dart';

import '../models/habito.dart';

class TarjetaHabito extends StatelessWidget {
  const TarjetaHabito({
    super.key,
    required this.habito,
    required this.onCambiar,
    required this.onEliminar,
  });

  final Habito habito;
  final VoidCallback onCambiar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: habito.completado,
          onChanged: (_) => onCambiar(),
        ),
        title: Text(
          habito.nombre,
          style: TextStyle(
            decoration: habito.completado ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          tooltip: 'Eliminar',
          icon: const Icon(Icons.delete_outline),
          onPressed: onEliminar,
        ),
      ),
    );
  }
}
