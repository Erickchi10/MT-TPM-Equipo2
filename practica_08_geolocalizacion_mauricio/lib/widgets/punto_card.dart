import 'package:flutter/material.dart';
import '../models/punto_interes.dart';

class PuntoCard extends StatelessWidget {
  final PuntoInteres punto;
  final double? distancia;
  final VoidCallback onAbrirMapa;
  final VoidCallback onEliminar;

  const PuntoCard({
    super.key,
    required this.punto,
    required this.distancia,
    required this.onAbrirMapa,
    required this.onEliminar,
  });

  String formatearDistancia(double? metros) {
    if (metros == null) {
      return 'Obtén tu ubicación';
    }

    if (metros >= 1000) {
      return '${(metros / 1000).toStringAsFixed(2)} km';
    }

    return '${metros.toStringAsFixed(0)} m';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(Icons.place, color: Color(0xFF1565C0)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    punto.nombre,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Eliminar punto',
                  onPressed: onEliminar,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Latitud: ${punto.latitud.toStringAsFixed(6)}'),
            Text('Longitud: ${punto.longitud.toStringAsFixed(6)}'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.social_distance,
                  color: Color(0xFF1565C0),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Distancia: ${formatearDistancia(distancia)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onAbrirMapa,
                icon: const Icon(Icons.map_outlined),
                label: const Text('Abrir en Google Maps'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
