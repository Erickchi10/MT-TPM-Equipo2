import 'dart:io';

import 'package:flutter/material.dart';

import '../models/inspeccion.dart';
import '../services/formato.dart';
import 'lectura_ejes.dart';

class TarjetaEvidencia extends StatelessWidget {
  const TarjetaEvidencia({
    super.key,
    required this.inspeccion,
    required this.onEliminar,
  });

  final Inspeccion inspeccion;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final i = inspeccion;
    final tema = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.file(
              File(i.fotoRuta),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: tema.colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: const Text('Foto no disponible'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(i.titulo, style: tema.textTheme.titleMedium),
                    ),
                    IconButton(
                      tooltip: 'Eliminar',
                      onPressed: onEliminar,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16),
                    const SizedBox(width: 4),
                    Text(Formato.fecha(i.fecha)),
                    const SizedBox(width: 16),
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 4),
                    Text(Formato.hora(i.fecha)),
                  ],
                ),
                const Divider(height: 20),
                LecturaEjes(
                  titulo: 'Acelerómetro (m/s²)',
                  lectura: i.acelerometro,
                ),
                const SizedBox(height: 8),
                LecturaEjes(
                  titulo: 'Giroscopio (rad/s)',
                  lectura: i.giroscopio,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
