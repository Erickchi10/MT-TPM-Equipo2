import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/db.dart';
import '../models/tarea.dart';
import '../services/prefs_service.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  List<Tarea> _tareas = [];
  String _filtro = 'Todas';
  String _nombreUsuario = 'Invitado';
  bool _isOffline = false;

  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();

    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (mounted) {
        setState(() {
          _isOffline = results.contains(ConnectivityResult.none);
        });
      }
    });
  }

  Future<void> _cargarDatos() async {
    final nombre = await PrefsService.leerNombre();
    final filtro = await PrefsService.leerFiltro();
    final tareas = await DB.listar();

    if (mounted) {
      setState(() {
        _nombreUsuario = nombre;
        _filtro = filtro;
        _tareas = tareas;
      });
    }
  }

  List<Tarea> get _tareasFiltradas {
    if (_filtro == 'Pendientes') {
      return _tareas.where((t) => !t.completada).toList();
    } else if (_filtro == 'Completadas') {
      return _tareas.where((t) => t.completada).toList();
    }
    return _tareas;
  }

  Future<void> _cambiarFiltro(String nuevoFiltro) async {
    setState(() => _filtro = nuevoFiltro);
    await PrefsService.guardarFiltro(nuevoFiltro);
  }

  void _mostrarDialogoTarea([Tarea? tareaExistente]) {
    final tituloCtrl = TextEditingController(
      text: tareaExistente?.titulo ?? '',
    );
    final descCtrl = TextEditingController(
      text: tareaExistente?.descripcion ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(tareaExistente == null ? 'Nueva Tarea' : 'Editar Tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloCtrl,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            onPressed: () async {
              final titulo = tituloCtrl.text.trim();
              final desc = descCtrl.text.trim();

              if (titulo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('El título no puede estar vacío'),
                  ),
                );
                return;
              }

              if (tareaExistente == null) {
                await DB.insertar(Tarea(titulo: titulo, descripcion: desc));
              } else {
                await DB.actualizar(
                  Tarea(
                    id: tareaExistente.id,
                    titulo: titulo,
                    descripcion: desc,
                    completada: tareaExistente.completada,
                    pendienteSincronizar: 1,
                  ),
                );
              }
              if (context.mounted) Navigator.pop(context);
              _cargarDatos();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(Tarea tarea) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar tarea'),
        content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DB.eliminar(tarea.id!);
              if (context.mounted) Navigator.pop(context);
              _cargarDatos();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _cambiarEstado(Tarea tarea) async {
    final actualizada = Tarea(
      id: tarea.id,
      titulo: tarea.titulo,
      descripcion: tarea.descripcion,
      completada: !tarea.completada,
      pendienteSincronizar: 1,
    );
    await DB.actualizar(actualizada);
    _cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo gris suave para contraste
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          'Hola, $_nombreUsuario',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('Cambiar nombre'),
                  content: TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Tu nombre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        if (_nombreController.text.isNotEmpty) {
                          await PrefsService.guardarNombre(
                            _nombreController.text,
                          );
                          _cargarDatos();
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Todas', 'Pendientes', 'Completadas'].map((f) {
                return ChoiceChip(
                  label: Text(f),
                  selected: _filtro == f,
                  onSelected: (selected) => _cambiarFiltro(f),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: _filtro == f ? Colors.white : Colors.black87,
                    fontWeight: _filtro == f
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
          // Aviso Offline mejorado
          if (_isOffline)
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

          // Lista de tareas
          Expanded(
            child: _tareasFiltradas.isEmpty
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
                    itemCount: _tareasFiltradas.length,
                    itemBuilder: (context, index) {
                      final tarea = _tareasFiltradas[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Checkbox(
                            value: tarea.completada,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (_) => _cambiarEstado(tarea),
                          ),
                          title: Text(
                            tarea.titulo,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: tarea.completada
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: tarea.completada
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                tarea.descripcion,
                                style: TextStyle(
                                  color: tarea.completada
                                      ? Colors.grey
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: tarea.pendienteSincronizar == 1
                                      ? Colors.orange[50]
                                      : Colors.green[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: tarea.pendienteSincronizar == 1
                                        ? Colors.orange
                                        : Colors.green,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  'Sync: ${tarea.pendienteSincronizar == 1 ? "Pendiente" : "Sincronizado"}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: tarea.pendienteSincronizar == 1
                                        ? Colors.orange[800]
                                        : Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _mostrarDialogoTarea(tarea),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmarEliminar(tarea),
                              ),
                            ],
                          ),
                          onTap: () => _mostrarDialogoTarea(tarea),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogoTarea(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tarea'),
      ),
    );
  }
}
