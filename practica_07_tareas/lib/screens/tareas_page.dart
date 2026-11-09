import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tarea.dart';
import '../providers/tareas_provider.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/filtro_tareas.dart';
import '../widgets/formulario_tarea.dart';
import '../widgets/tarjeta_tarea.dart';

class TareasPage extends StatelessWidget {
  const TareasPage({super.key});

  Future<void> _confirmarEliminar(BuildContext context, Tarea tarea) async {
    final provider = context.read<TareasProvider>();
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Eliminar "${tarea.titulo}"?'),
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
    if (confirmado == true) {
      await provider.eliminar(tarea.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')),
      body: Consumer<TareasProvider>(
        builder: (context, p, _) {
          if (p.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              FiltroTareas(filtro: p.filtro, onCambiar: p.cambiarFiltro),
              FormularioTarea(
                editando: p.editando,
                onGuardar: p.guardar,
                onCancelar: p.cancelarEdicion,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: p.tareas.isEmpty
                    ? EstadoVacio(filtro: p.filtro)
                    : ListView.builder(
                        itemCount: p.tareas.length,
                        itemBuilder: (context, i) {
                          final t = p.tareas[i];
                          return TarjetaTarea(
                            tarea: t,
                            onCambiar: () => p.alternar(t),
                            onEditar: () => p.empezarEdicion(t),
                            onEliminar: () => _confirmarEliminar(context, t),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
