import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tarea.dart';

class TarjetaTarea extends StatelessWidget {
  const TarjetaTarea({
    super.key,
    required this.tarea,
    required this.onAlternar,
    required this.onEliminar,
  });

  static final DateFormat _formatoFecha = DateFormat('dd/MM/yyyy HH:mm');

  final Tarea tarea;
  final VoidCallback onAlternar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: tarea.completada,
          onChanged: (_) => onAlternar(),
        ),
        title: Text(
          tarea.titulo,
          style: TextStyle(
            decoration: tarea.completada ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('Creada: ${_formatoFecha.format(tarea.creada)}'),
        trailing: IconButton(
          tooltip: 'Eliminar',
          icon: const Icon(Icons.delete_outline),
          onPressed: onEliminar,
        ),
      ),
    );
  }
}
