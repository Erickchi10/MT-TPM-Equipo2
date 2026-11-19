import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../providers/tareas_provider.dart';
import '../widgets/tarea_card.dart';
import '../widgets/formulario_tarea.dart';
import '../models/tarea.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar tareas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TareasProvider>().cargarTareas();
    });

    // Escuchar conexión
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (mounted) {
        context.read<TareasProvider>().setOffline(
          results.contains(ConnectivityResult.none),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // context.watch escucha los cambios del Provider y reconstruye la UI
    final provider = context.watch<TareasProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text(
          'Gestor de Tareas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Todas', 'Pendientes', 'Completadas'].map((f) {
                return ChoiceChip(
                  label: Text(f),
                  selected: provider.filtro == f,
                  onSelected: (selected) => provider.cambiarFiltro(f),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: provider.filtro == f ? Colors.white : Colors.black87,
                    fontWeight: provider.filtro == f
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (provider.isOffline)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.redAccent[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent),
              ),
              child: const Row(
                children: [
                  Icon(Icons.cloud_off, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Modo offline: Guardando datos localmente.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: provider.tareasFiltradas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay tareas aquí',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: provider.tareasFiltradas.length,
                    itemBuilder: (context, index) {
                      final tarea = provider.tareasFiltradas[index];
                      return TareaCard(
                        tarea: tarea,
                        onToggle: () => provider.cambiarEstado(tarea),
                        onEdit: () => _mostrarFormulario(tarea: tarea),
                        onDelete: () => _confirmarEliminar(tarea),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tarea'),
      ),
    );
  }

  void _mostrarFormulario({Tarea? tarea}) {
    showDialog(
      context: context,
      builder: (ctx) => FormularioTarea(
        tituloInicial: tarea?.titulo,
        descInicial: tarea?.descripcion,
        onGuardar: (titulo, desc) {
          if (tarea == null) {
            context.read<TareasProvider>().agregarTarea(titulo, desc);
          } else {
            final actualizada = Tarea(
              id: tarea.id,
              titulo: titulo,
              descripcion: desc,
              completada: tarea.completada,
              pendienteSincronizar: 1,
            );
            context.read<TareasProvider>().actualizarTarea(actualizada);
          }
        },
      ),
    );
  }

  void _confirmarEliminar(Tarea tarea) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<TareasProvider>().eliminarTarea(tarea.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
