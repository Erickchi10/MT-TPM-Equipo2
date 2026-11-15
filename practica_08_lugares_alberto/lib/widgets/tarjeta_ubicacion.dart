import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lugares_provider.dart';
import '../services/mapa_service.dart';
import '../services/ubicacion_service.dart';

class TarjetaUbicacion extends StatelessWidget {
  const TarjetaUbicacion({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<LugaresProvider>();
    final r = prov.resultado;
    final tema = Theme.of(context);
    return Card(
      color: tema.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.my_location),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(prov.mensaje, style: tema.textTheme.titleSmall),
                ),
              ],
            ),
            if (prov.tieneUbicacion) ...[
              const SizedBox(height: 8),
              Text('Latitud: ${r!.latitud!.toStringAsFixed(6)}'),
              Text('Longitud: ${r.longitud!.toStringAsFixed(6)}'),
              Text('Precisión: ${r.precision!.toStringAsFixed(1)} m'),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: prov.buscando ? null : prov.obtenerUbicacion,
                  icon: prov.buscando
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.gps_fixed),
                  label: const Text('Mi ubicación'),
                ),
                if (prov.tieneUbicacion)
                  OutlinedButton.icon(
                    onPressed: () =>
                        MapaService.abrir(r!.latitud!, r.longitud!),
                    icon: const Icon(Icons.map),
                    label: const Text('Ver en mapa'),
                  ),
                if (r?.estado == EstadoUbicacion.permisoBloqueado)
                  TextButton(
                    onPressed: prov.abrirAjustes,
                    child: const Text('Abrir ajustes'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
