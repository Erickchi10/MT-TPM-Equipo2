import 'package:flutter/material.dart';

class EncabezadoResumen extends StatelessWidget {
  const EncabezadoResumen({
    super.key,
    required this.completados,
    required this.total,
  });

  final int completados;
  final int total;

  @override
  Widget build(BuildContext context) {
    final avance = total == 0 ? 0.0 : completados / total;
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completados: $completados de $total',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: avance),
          ],
        ),
      ),
    );
  }
}
