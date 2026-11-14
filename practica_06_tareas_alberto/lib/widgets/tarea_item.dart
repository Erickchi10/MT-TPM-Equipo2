import 'package:flutter/material.dart';

import '../models/tarea.dart';

class TareaItem extends StatelessWidget {
  final Tarea tarea;
  final ValueChanged<bool?> alMarcar;
  final VoidCallback alTocar;

  const TareaItem({
    super.key,
    required this.tarea,
    required this.alMarcar,
    required this.alTocar,
  });

  Color get _colorPrioridad => switch (tarea.prioridad) {
    Prioridad.alta => Colors.red,
    Prioridad.media => Colors.orange,
    Prioridad.baja => Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    final detalle = tarea.descripcion.isEmpty
        ? 'Prioridad ${tarea.prioridad.etiqueta}'
        : '${tarea.descripcion}\nPrioridad ${tarea.prioridad.etiqueta}';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Checkbox(value: tarea.completada, onChanged: alMarcar),
        title: Text(
          tarea.titulo,
          style: TextStyle(
            decoration: tarea.completada ? TextDecoration.lineThrough : null,
            color: tarea.completada ? Colors.grey : null,
          ),
        ),
        subtitle: Text(detalle, maxLines: 3, overflow: TextOverflow.ellipsis),
        isThreeLine: tarea.descripcion.isNotEmpty,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tarea.pendienteSincronizar)
              const Tooltip(
                message: 'Pendiente de sincronizar',
                child: Icon(Icons.cloud_off, size: 18, color: Colors.grey),
              ),
            const SizedBox(width: 8),
            CircleAvatar(radius: 6, backgroundColor: _colorPrioridad),
          ],
        ),
        onTap: alTocar,
      ),
    );
  }
}
