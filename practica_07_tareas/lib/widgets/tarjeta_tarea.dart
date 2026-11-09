import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tarea.dart';

class TarjetaTarea extends StatelessWidget {
  const TarjetaTarea({
    super.key,
    required this.tarea,
    required this.onCambiar,
    required this.onEditar,
    required this.onEliminar,
  });

  final Tarea tarea;
  final VoidCallback onCambiar;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('dd/MM/yyyy HH:mm').format(tarea.fechaCreacion);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: tarea.completada,
          onChanged: (_) => onCambiar(),
        ),
        title: Text(
          tarea.titulo,
          style: TextStyle(
            decoration: tarea.completada ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              tarea.pendienteSincronizar ? Icons.cloud_off : Icons.cloud_done,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text('Creada: $fecha'),
          ],
        ),
        onTap: onEditar,
        trailing: IconButton(
          tooltip: 'Eliminar',
          icon: const Icon(Icons.delete_outline),
          onPressed: onEliminar,
        ),
      ),
    );
  }
}
