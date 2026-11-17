import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tarea.dart';
import '../providers/tareas_provider.dart';
import '../widgets/dialogo_nueva_tarea.dart';
import '../widgets/encabezado_seccion.dart';
import '../widgets/tarjeta_tarea.dart';
import 'contador_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _agregar(BuildContext context) async {
    final titulo = await showDialog<String>(
      context: context,
      builder: (_) => const DialogoNuevaTarea(),
    );
    if (titulo == null || !context.mounted) return;
    await context.read<TareasProvider>().agregar(titulo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(
            tooltip: 'Práctica guiada: contador',
            icon: const Icon(Icons.exposure_plus_1),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ContadorScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar tarea',
        onPressed: () => _agregar(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Builder(
            builder: (context) {
              final pendientes = context.select<TareasProvider, int>(
                (p) => p.pendientes,
              );
              return EncabezadoSeccion(
                titulo: 'Pendientes: $pendientes',
                subtitulo: 'Arquitectura por capas con Provider',
              );
            },
          ),
          const Expanded(child: _ListaTareas()),
        ],
      ),
    );
  }
}

class _ListaTareas extends StatelessWidget {
  const _ListaTareas();

  @override
  Widget build(BuildContext context) {
    final cargando = context.select<TareasProvider, bool>((p) => p.cargando);
    final tareas = context.watch<TareasProvider>().tareas;

    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tareas.isEmpty) {
      return const Center(child: Text('Sin tareas. Pulsa + para agregar.'));
    }

    return ListView.builder(
      itemCount: tareas.length,
      itemBuilder: (context, indice) {
        final Tarea tarea = tareas[indice];
        return TarjetaTarea(
          key: ValueKey(tarea.id),
          tarea: tarea,
          onAlternar: () => context.read<TareasProvider>().alternar(tarea),
          onEliminar: () => context.read<TareasProvider>().eliminar(tarea.id),
        );
      },
    );
  }
}
