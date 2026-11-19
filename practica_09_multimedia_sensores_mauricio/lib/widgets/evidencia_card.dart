import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/evidencia.dart';

class EvidenciaCard extends StatelessWidget {
  final Evidencia evidencia;
  final VoidCallback onEliminar;

  const EvidenciaCard({
    super.key,
    required this.evidencia,
    required this.onEliminar,
  });

  Widget construirDato(String titulo, double valor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            valor.toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(
            File(evidencia.imagePath),
            height: 190,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 190,
                child: Center(child: Icon(Icons.broken_image, size: 45)),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Evidencia de inspección',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format(evidencia.fecha)}',
                ),
                Text('Hora: ${DateFormat('HH:mm:ss').format(evidencia.fecha)}'),
                const Divider(height: 25),
                const Text(
                  'Acelerómetro (m/s²)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    construirDato('X', evidencia.acelerometroX),
                    construirDato('Y', evidencia.acelerometroY),
                    construirDato('Z', evidencia.acelerometroZ),
                  ],
                ),
                const Divider(height: 25),
                const Text(
                  'Giroscopio (rad/s)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    construirDato('X', evidencia.giroscopioX),
                    construirDato('Y', evidencia.giroscopioY),
                    construirDato('Z', evidencia.giroscopioZ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onEliminar,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Eliminar evidencia'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
