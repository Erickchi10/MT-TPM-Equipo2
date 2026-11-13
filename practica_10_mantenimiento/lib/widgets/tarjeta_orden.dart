import 'dart:io';

import 'package:flutter/material.dart';

import '../models/orden.dart';

class TarjetaOrden extends StatelessWidget {
  const TarjetaOrden({super.key, required this.orden, required this.onTap});

  final Orden orden;
  final VoidCallback onTap;

  Color get _colorEstado {
    switch (orden.estado) {
      case EstadoOrden.pendiente:
        return Colors.orange;
      case EstadoOrden.enProceso:
        return Colors.blue;
      case EstadoOrden.terminada:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final foto = orden.fotoPath;
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
                    child: Icon(Icons.build),
                  ),
          ),
        ),
        title: Text(orden.equipo, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          'Prioridad ${orden.prioridad} · ${orden.tecnico}\n'
          '${orden.fechaTexto} ${orden.horaTexto}',
        ),
        isThreeLine: true,
        trailing: Chip(
          label: Text(
            orden.estado.texto,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: _colorEstado,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
