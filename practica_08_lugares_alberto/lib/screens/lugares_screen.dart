import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lugar.dart';
import '../providers/lugares_provider.dart';
import '../services/mapa_service.dart';
import '../widgets/lugar_tile.dart';
import '../widgets/tarjeta_ubicacion.dart';
import 'form_lugar.dart';

class LugaresScreen extends StatelessWidget {
  const LugaresScreen({super.key});

  Future<void> _abrirMapa(BuildContext context, Lugar l) async {
    final ok = await MapaService.abrir(l.latitud, l.longitud);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo abrir el mapa')));
    }
  }

  Future<void> _confirmarEliminar(BuildContext context, Lugar l) async {
    final prov = context.read<LugaresProvider>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar lugar'),
        content: Text('¿Eliminar "${l.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) await prov.eliminar(l.id);
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<LugaresProvider>();
    final lista = prov.lugares;
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de interés')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormLugar()),
        ),
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Agregar lugar'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TarjetaUbicacion(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Text(
                  'Mis lugares (${lista.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (prov.tieneUbicacion && lista.isNotEmpty)
                  const Text('Del más cercano al más lejano'),
              ],
            ),
          ),
          Expanded(
            child: lista.isEmpty
                ? const Center(
                    child: Text(
                      'Aún no guardas lugares.\nToca "Agregar lugar".',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: lista.length,
                    itemBuilder: (context, i) {
                      final l = lista[i];
                      return LugarTile(
                        lugar: l,
                        distancia: prov.distanciaA(l),
                        alAbrirMapa: () => _abrirMapa(context, l),
                        alEliminar: () => _confirmarEliminar(context, l),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
