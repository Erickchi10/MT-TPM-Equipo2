import 'package:flutter/material.dart';

class EstadoError extends StatelessWidget {
  final String mensaje;
  final VoidCallback alReintentar;

  const EstadoError({
    super.key,
    required this.mensaje,
    required this.alReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 64),
            const SizedBox(height: 12),
            Text(
              'No se pudieron cargar las publicaciones\n$mensaje',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: alReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
