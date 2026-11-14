import 'package:flutter/material.dart';

import '../data/preferencias.dart';
import '../data/tareas_db.dart';
import '../models/orden.dart';
import '../models/tarea.dart';
import '../widgets/tarea_item.dart';
import 'form_tarea.dart';

class ListaTareas extends StatefulWidget {
  const ListaTareas({super.key});

  @override
  State<ListaTareas> createState() => _ListaTareasState();
}

class _ListaTareasState extends State<ListaTareas> {
  List<Tarea> _todas = [];
  bool _cargando = true;
  bool _mostrarCompletadas = true;
  OrdenTareas _orden = OrdenTareas.prioridad;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final mostrar = await PreferenciasUI.leerMostrarCompletadas();
    final orden = await PreferenciasUI.leerOrden();
    final tareas = await TareasDB.listar();
    if (!mounted) return;
    setState(() {
      _mostrarCompletadas = mostrar;
      _orden = orden;
      _todas = tareas;
      _cargando = false;
    });
  }

  Future<void> _recargar() async {
    final tareas = await TareasDB.listar();
    if (!mounted) return;
    setState(() => _todas = tareas);
  }

  void _aviso(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _abrirFormulario([Tarea? tarea]) async {
    final resultado = await Navigator.push<Tarea>(
      context,
      MaterialPageRoute(builder: (_) => FormTarea(tarea: tarea)),
    );
    if (resultado == null) return;
    if (tarea == null) {
      await TareasDB.insertar(resultado);
      _aviso('Tarea creada');
    } else {
      await TareasDB.actualizar(resultado);
      _aviso('Tarea actualizada');
    }
    await _recargar();
  }

  Future<void> _marcar(Tarea tarea, bool? valor) async {
    await TareasDB.actualizar(tarea.copyWith(completada: valor ?? false));
    await _recargar();
  }

  Future<bool> _confirmarEliminar(Tarea tarea) async {
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
    return confirmado ?? false;
  }

  Future<void> _eliminar(Tarea tarea) async {
    // Se quita de la lista al instante para que el Dismissible no se quede.
    setState(() => _todas.removeWhere((t) => t.id == tarea.id));
    await TareasDB.eliminar(tarea.id!);
    _aviso('Tarea eliminada');
  }

  Future<void> _cambiarOrden(OrdenTareas orden) async {
    setState(() => _orden = orden);
    await PreferenciasUI.guardarOrden(orden);
  }

  Future<void> _alternarCompletadas() async {
    final nuevo = !_mostrarCompletadas;
    setState(() => _mostrarCompletadas = nuevo);
    await PreferenciasUI.guardarMostrarCompletadas(nuevo);
  }

  @override
  Widget build(BuildContext context) {
    final visibles = organizarTareas(
      _todas,
      orden: _orden,
      mostrarCompletadas: _mostrarCompletadas,
    );
    final pendientes = _todas.where((t) => !t.completada).length;
    final hechas = _todas.length - pendientes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(
            tooltip: _mostrarCompletadas
                ? 'Ocultar completadas'
                : 'Mostrar completadas',
            icon: Icon(
              _mostrarCompletadas ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: _alternarCompletadas,
          ),
          PopupMenuButton<OrdenTareas>(
            tooltip: 'Ordenar',
            icon: const Icon(Icons.sort),
            initialValue: _orden,
            onSelected: _cambiarOrden,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: OrdenTareas.prioridad,
                child: Text('Por prioridad'),
              ),
              PopupMenuItem(
                value: OrdenTareas.recientes,
                child: Text('Más recientes'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      Text('$pendientes pendientes · $hechas completadas'),
                      const Spacer(),
                      const Icon(Icons.storage, size: 18),
                      const SizedBox(width: 4),
                      const Text('Local'),
                    ],
                  ),
                ),
                Expanded(
                  child: visibles.isEmpty
                      ? Center(
                          child: Text(
                            _todas.isEmpty
                                ? 'No hay tareas.\nToca "Nueva" para crear una.'
                                : 'No hay tareas para mostrar',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 88),
                          itemCount: visibles.length,
                          itemBuilder: (context, i) {
                            final tarea = visibles[i];
                            return Dismissible(
                              key: ValueKey(tarea.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (_) => _confirmarEliminar(tarea),
                              onDismissed: (_) => _eliminar(tarea),
                              child: TareaItem(
                                tarea: tarea,
                                alMarcar: (v) => _marcar(tarea, v),
                                alTocar: () => _abrirFormulario(tarea),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
