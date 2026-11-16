import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/incidencias_provider.dart';

class AvisosScreen extends StatelessWidget {
  const AvisosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<IncidenciasProvider>();
    final Widget cuerpo = switch (p.estadoAvisos) {
      EstadoAvisos.cargando => const Center(child: CircularProgressIndicator()),
      EstadoAvisos.sinConexion => _Mensaje(
        icono: Icons.wifi_off,
        texto: 'Sin conexión. Tus reportes guardados siguen disponibles.',
        onReintentar: p.cargarAvisos,
      ),
      EstadoAvisos.error => _Mensaje(
        icono: Icons.error_outline,
        texto: 'No se pudieron cargar los avisos.',
        onReintentar: p.cargarAvisos,
      ),
      EstadoAvisos.ok => RefreshIndicator(
        onRefresh: p.cargarAvisos,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: p.avisos.length,
          itemBuilder: (_, k) {
            final a = p.avisos[k];
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${a.id}')),
                title: Text(a.titulo),
                subtitle: Text(
                  a.cuerpo,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
      ),
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Avisos (API REST)')),
      body: cuerpo,
    );
  }
}

class _Mensaje extends StatelessWidget {
  const _Mensaje({
    required this.icono,
    required this.texto,
    required this.onReintentar,
  });

  final IconData icono;
  final String texto;
  final Future<void> Function() onReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56),
            const SizedBox(height: 12),
            Text(texto, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
