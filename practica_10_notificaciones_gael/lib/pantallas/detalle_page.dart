
import 'dart:io';

import 'package:flutter/material.dart';
import '../modelos/inspeccion.dart';

class DetallePage extends StatelessWidget {
  final Inspeccion inspeccion;

  const DetallePage({
    super.key,
    required this.inspeccion,
  });

  String valor(double? numero) {
    return numero?.toStringAsFixed(2) ?? 'No disponible';
  }

  Widget seccion(String titulo, List<Widget> contenido) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...contenido,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fotoPath = inspeccion.fotoPath;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de inspección'),
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              inspeccion.titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text('Categoría: ${inspeccion.categoria}'),
            Text('Fecha: ${inspeccion.fecha}'),

            const SizedBox(height: 16),

            if (fotoPath != null &&
                File(fotoPath).existsSync()) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(fotoPath),
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],

            seccion('Descripción', [
              Text(inspeccion.descripcion),
            ]),

            seccion('Ubicación GPS', [
              Text('Latitud: ${valor(inspeccion.latitud)}'),
              Text('Longitud: ${valor(inspeccion.longitud)}'),
            ]),

            seccion('Acelerómetro', [
              Text('X: ${valor(inspeccion.acelerometroX)}'),
              Text('Y: ${valor(inspeccion.acelerometroY)}'),
              Text('Z: ${valor(inspeccion.acelerometroZ)}'),
            ]),

            seccion('Giroscopio', [
              Text('X: ${valor(inspeccion.giroscopioX)}'),
              Text('Y: ${valor(inspeccion.giroscopioY)}'),
              Text('Z: ${valor(inspeccion.giroscopioZ)}'),
            ]),

            seccion('Sincronización', [
              Text(
                inspeccion.sincronizado
                    ? 'Sincronizado'
                    : 'Pendiente de sincronización',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
