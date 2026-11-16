import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/inspeccion.dart';
import '../providers/bitacora_provider.dart';
import '../widgets/tarjeta_evidencia.dart';
import 'nueva_inspeccion_screen.dart';

class BitacoraScreen extends StatelessWidget {
  const BitacoraScreen({super.key});

  Future<void> _nueva(BuildContext context) async {
    final mensaje = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const NuevaInspeccionScreen()),
    );
    if (mensaje != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }

  Future<void> _eliminar(BuildContext context, Inspeccion i) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar inspección'),
        content: Text('¿Eliminar "${i.titulo}"?'),
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
    if (confirmar == true && context.mounted) {
      await context.read<BitacoraProvider>().eliminar(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bitacora = context.watch<BitacoraProvider>();
    final lista = bitacora.inspecciones;

    Widget cuerpo;
    if (bitacora.cargando) {
      cuerpo = const Center(child: CircularProgressIndicator());
    } else if (lista.isEmpty) {
      cuerpo = const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Aún no hay inspecciones.\n'
            'Toca "Nueva inspección" para registrar la primera.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      cuerpo = ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
        itemCount: lista.length,
        itemBuilder: (_, k) => TarjetaEvidencia(
          inspeccion: lista[k],
          onEliminar: () => _eliminar(context, lista[k]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Bitácora de inspección (${lista.length})')),
      body: cuerpo,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _nueva(context),
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Nueva inspección'),
      ),
    );
  }
}
