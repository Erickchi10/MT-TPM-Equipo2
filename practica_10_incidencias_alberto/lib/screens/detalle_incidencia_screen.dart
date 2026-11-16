import 'dart:io';

import 'package:flutter/material.dart';

import '../models/incidencia.dart';
import '../services/formato.dart';
import '../widgets/incidencia_tile.dart';

class DetalleIncidenciaScreen extends StatelessWidget {
  const DetalleIncidenciaScreen({super.key, required this.incidencia});

  final Incidencia incidencia;

  @override
  Widget build(BuildContext context) {
    final i = incidencia;
    final foto = i.fotoRuta;
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del reporte')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (foto != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.file(
                  File(foto),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Text('Foto no disponible')),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(i.titulo, style: tema.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Wrap(
            children: [
              Chip(
                avatar: Icon(iconoCategoria(i.categoria), size: 18),
                label: Text(i.categoria),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(i.descripcion, style: tema.textTheme.bodyLarge),
          const Divider(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event),
            title: const Text('Fecha y hora'),
            subtitle: Text(
              '${Formato.fecha(i.fecha)} ${Formato.hora(i.fecha)}',
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.location_on),
            title: const Text('Ubicación'),
            subtitle: Text(
              i.tieneUbicacion
                  ? '${i.latitud!.toStringAsFixed(6)}, '
                        '${i.longitud!.toStringAsFixed(6)}'
                  : 'Sin ubicación',
            ),
          ),
        ],
      ),
    );
  }
}
