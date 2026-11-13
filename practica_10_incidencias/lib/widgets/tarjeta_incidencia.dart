import 'dart:io';

import 'package:flutter/material.dart';

import '../models/incidencia.dart';

class TarjetaIncidencia extends StatelessWidget {
  const TarjetaIncidencia({
    super.key,
    required this.incidencia,
    required this.onTap,
    this.onEliminar,
  });

  final Incidencia incidencia;
  final VoidCallback onTap;
  final VoidCallback? onEliminar;

  @override
  Widget build(BuildContext context) {
    final foto = incidencia.fotoPath;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 56,
            height: 56,
            child: foto != null && File(foto).existsSync()
                ? Image.file(File(foto), fit: BoxFit.cover)
                : const ColoredBox(
                    color: Color(0xFFE0E0E0),
                    child: Icon(Icons.image_not_supported),
                  ),
          ),
        ),
        title: Text(
          incidencia.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${incidencia.categoria}\n${incidencia.fechaTexto} ${incidencia.horaTexto}',
        ),
        isThreeLine: true,
        trailing: onEliminar == null
            ? const Icon(Icons.chevron_right)
            : IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Eliminar',
                onPressed: onEliminar,
              ),
      ),
    );
  }
}
