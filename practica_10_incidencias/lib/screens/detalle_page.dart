import 'dart:io';

import 'package:flutter/material.dart';

import '../models/incidencia.dart';

class DetallePage extends StatelessWidget {
  const DetallePage({super.key, required this.incidencia});

  final Incidencia incidencia;

  @override
  Widget build(BuildContext context) {
    final foto = incidencia.fotoPath;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del reporte')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (foto != null && File(foto).existsSync())
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(foto), fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          Text(
            incidencia.titulo,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Chip(label: Text(incidencia.categoria)),
          const SizedBox(height: 8),
          Text(incidencia.descripcion),
          const Divider(height: 32),
          _Dato(icono: Icons.calendar_today, texto: incidencia.fechaTexto),
          _Dato(icono: Icons.access_time, texto: incidencia.horaTexto),
          _Dato(icono: Icons.location_on, texto: incidencia.ubicacionTexto),
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icono, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}
