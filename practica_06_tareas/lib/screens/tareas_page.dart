import 'package:flutter/material.dart';

import '../database/db.dart';
import '../models/tarea.dart';
import '../preferencias.dart';

class TareasPage extends StatefulWidget {
  const TareasPage({super.key});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final _titulo = TextEditingController();
  List<Tarea> _tareas = [];
  Tarea? _editando;
  String _filtro = 'todas';
  String? _error;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  @override
  void dispose() {
    _titulo.dispose();
    super.dispose();
  }

  Future<void> _iniciar() async {
    final filtro = await Preferencias.leerFiltro();
    final tareas = await DB.listar(filtro);
    if (!mounted) return;
    setState(() {
      _filtro = filtro;
      _tareas = tareas;
    });
  }

  Future<void> _recargar() async {
    final tareas = await DB.listar(_filtro);
    if (!mounted) return;
    setState(() => _tareas = tareas);
  }

  Future<void> _cambiarFiltro(String filtro) async {
    await Preferencias.guardarFiltro(filtro);
    if (!mounted) return;
    setState(() => _filtro = filtro);
    await _recargar();
  }

  void _limpiar() {
    _titulo.clear();
    setState(() {
      _editando = null;
      _error = null;
    });
  }

  Future<void> _guardar() async {
    final titulo = _titulo.text.trim();
    String? error;
    if (titulo.isEmpty) {
      error = 'Escribe el título de la tarea';
    } else if (titulo.length < 3) {
      error = 'Mínimo 3 caracteres';
    } else if (titulo.length > 60) {
      error = 'Máximo 60 caracteres';
    } else if (await DB.existeTitulo(titulo, exceptoId: _editando?.id)) {
      error = 'Esa tarea ya existe';
    }
    if (error != null) {
      if (!mounted) return;
      setState(() => _error = error);
      return;
    }
    if (_editando == null) {
      await DB.insertar(Tarea(titulo: titulo));
    } else {
      await DB.actualizar(_editando!.copiarCon(titulo: titulo));
    }
    _limpiar();
    await _recargar();
  }

  void _editar(Tarea tarea) {
    _titulo.text = tarea.titulo;
    setState(() {
      _editando = tarea;
      _error = null;
    });
  }

  Future<void> _alternar(Tarea tarea) async {
    await DB.actualizar(tarea.copiarCon(completada: !tarea.completada));
    await _recargar();
  }

  Future<void> _eliminar(Tarea tarea) async {
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
      await DB.eliminar(tarea.id!);
      if (_editando?.id == tarea.id) _limpiar();
      await _recargar();
    }
  }

  String get _textoVacio {
    switch (_filtro) {
      case 'pendientes':
        return 'No hay tareas pendientes';
      case 'completadas':
        return 'No hay tareas completadas';
      default:
        return 'No hay tareas guardadas';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mis tareas')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titulo,
                decoration: InputDecoration(
                  labelText: 'Tarea',
                  border: const OutlineInputBorder(),
                  errorText: _error,
                ),
                onSubmitted: (_) => _guardar(),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _guardar,
                    child: Text(_editando == null ? 'Agregar' : 'Actualizar'),
                  ),
                  if (_editando != null) ...[
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _limpiar,
                      child: const Text('Cancelar'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'todas', label: Text('Todas')),
                  ButtonSegment(value: 'pendientes', label: Text('Pendientes')),
                  ButtonSegment(
                    value: 'completadas',
                    label: Text('Completadas'),
                  ),
                ],
                selected: {_filtro},
                onSelectionChanged: (s) => _cambiarFiltro(s.first),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _tareas.isEmpty
              ? Center(child: Text(_textoVacio))
              : ListView.builder(
                  itemCount: _tareas.length,
                  itemBuilder: (_, i) {
                    final tarea = _tareas[i];
                    return ListTile(
                      leading: Checkbox(
                        value: tarea.completada,
                        onChanged: (_) => _alternar(tarea),
                      ),
                      title: Text(
                        tarea.titulo,
                        style: TextStyle(
                          decoration: tarea.completada
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tarea.pendienteSincronizar
                                ? Icons.cloud_off
                                : Icons.cloud_done,
                            size: 20,
                          ),
                          IconButton(
                            tooltip: 'Eliminar',
                            icon: const Icon(Icons.delete),
                            onPressed: () => _eliminar(tarea),
                          ),
                        ],
                      ),
                      onTap: () => _editar(tarea),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
