import 'package:flutter/material.dart';
import '../models/tarea.dart';

class TareaCard extends StatelessWidget {
  final Tarea tarea;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TareaCard({
    super.key,
    required this.tarea,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: tarea.completada,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          tarea.titulo,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: tarea.completada ? TextDecoration.lineThrough : null,
            color: tarea.completada ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              tarea.descripcion,
              style: TextStyle(
                color: tarea.completada ? Colors.grey : Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: tarea.pendienteSincronizar == 1
                    ? Colors.orange[50]
                    : Colors.green[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: tarea.pendienteSincronizar == 1
                      ? Colors.orange
                      : Colors.green,
                  width: 0.5,
                ),
              ),
              child: Text(
                'Sync: ${tarea.pendienteSincronizar == 1 ? "Pendiente" : "Sincronizado"}',
                style: TextStyle(
                  fontSize: 10,
                  color: tarea.pendienteSincronizar == 1
                      ? Colors.orange[800]
                      : Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
