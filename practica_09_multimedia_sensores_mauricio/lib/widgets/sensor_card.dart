import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final double x;
  final double y;
  final double z;
  final String unidad;

  const SensorCard({
    super.key,
    required this.titulo,
    required this.icono,
    required this.x,
    required this.y,
    required this.z,
    required this.unidad,
  });

  Widget construirValor(String eje, double valor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            eje,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${valor.toStringAsFixed(2)} $unidad',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                construirValor('X', x),
                construirValor('Y', y),
                construirValor('Z', z),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
