import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/reporte.dart';

class DetalleReportePage extends StatelessWidget {
  final Reporte reporte;

  const DetalleReportePage({super.key, required this.reporte});

  Widget _dato(String titulo, String valor, IconData icono) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(valor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del reporte')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (reporte.imagenPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(reporte.imagenPath!),
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image_outlined, size: 55),
                  );
                },
              ),
            )
          else
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 55,
                color: Colors.blueGrey,
              ),
            ),

          const SizedBox(height: 24),

          Text(
            reporte.titulo,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 22),

          _dato('Descripción', reporte.descripcion, Icons.description_outlined),

          _dato('Categoría', reporte.categoria, Icons.category_outlined),

          _dato(
            'Fecha y hora',
            DateFormat('dd/MM/yyyy HH:mm:ss').format(reporte.fecha),
            Icons.calendar_today_outlined,
          ),

          _dato(
            'Latitud',
            reporte.latitud?.toString() ?? 'No disponible',
            Icons.location_on_outlined,
          ),

          _dato(
            'Longitud',
            reporte.longitud?.toString() ?? 'No disponible',
            Icons.location_on_outlined,
          ),

          _dato(
            'Identificador',
            reporte.id?.toString() ?? 'No disponible',
            Icons.tag,
          ),
        ],
      ),
    );
  }
}
