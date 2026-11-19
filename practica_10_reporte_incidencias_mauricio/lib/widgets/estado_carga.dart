import 'package:flutter/material.dart';

enum TipoEstado { cargando, error, vacio }

class EstadoCarga extends StatelessWidget {
  final TipoEstado tipo;
  final String mensaje;
  final VoidCallback? onReintentar;

  const EstadoCarga({
    super.key,
    required this.tipo,
    required this.mensaje,
    this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icono;
    final Color color;

    switch (tipo) {
      case TipoEstado.cargando:
        icono = Icons.hourglass_empty;
        color = Colors.blue;
        break;
      case TipoEstado.error:
        icono = Icons.cloud_off_outlined;
        color = Colors.red;
        break;
      case TipoEstado.vacio:
        icono = Icons.inbox_outlined;
        color = Colors.blueGrey;
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tipo == TipoEstado.cargando)
              const CircularProgressIndicator()
            else
              Icon(icono, size: 65, color: color),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (tipo == TipoEstado.error && onReintentar != null) ...[
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: onReintentar,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
