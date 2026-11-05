import 'package:flutter/material.dart';

import '../database/db.dart';
import '../models/nota.dart';
import '../preferencias.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final _titulo = TextEditingController();
  final _contenido = TextEditingController();
  List<Nota> _notas = [];
  Nota? _editando;
  String _nombre = '';

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  @override
  void dispose() {
    _titulo.dispose();
    _contenido.dispose();
    super.dispose();
  }

  Future<void> _iniciar() async {
    final nombre = await Preferencias.leerNombre();
    final notas = await DB.listar();
    if (!mounted) return;
    setState(() {
      _nombre = nombre ?? '';
      _notas = notas;
    });
  }

  Future<void> _recargar() async {
    final notas = await DB.listar();
    if (!mounted) return;
    setState(() => _notas = notas);
  }

  void _limpiar() {
    _titulo.clear();
    _contenido.clear();
    setState(() => _editando = null);
  }

  Future<void> _guardar() async {
    final titulo = _titulo.text.trim();
    final contenido = _contenido.text.trim();
    if (titulo.isEmpty || contenido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe el título y el contenido')),
      );
      return;
    }
    if (_editando == null) {
      await DB.insertar(Nota(titulo: titulo, contenido: contenido));
    } else {
      await DB.actualizar(
        Nota(id: _editando!.id, titulo: titulo, contenido: contenido),
      );
    }
    _limpiar();
    await _recargar();
  }

  void _editar(Nota nota) {
    _titulo.text = nota.titulo;
    _contenido.text = nota.contenido;
    setState(() => _editando = nota);
  }

  Future<void> _eliminar(Nota nota) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('¿Eliminar "${nota.titulo}"?'),
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
      await DB.eliminar(nota.id!);
      if (_editando?.id == nota.id) _limpiar();
      await _recargar();
    }
  }

  Future<void> _cambiarNombre() async {
    final controlador = TextEditingController(text: _nombre);
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tu nombre'),
        content: TextField(
          controller: controlador,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controlador.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    controlador.dispose();
    if (nuevo == null || nuevo.isEmpty) return;
    await Preferencias.guardarNombre(nuevo);
    if (!mounted) return;
    setState(() => _nombre = nuevo);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_nombre.isEmpty ? 'Mis notas' : 'Notas de $_nombre'),
      actions: [
        IconButton(
          tooltip: 'Cambiar nombre',
          icon: const Icon(Icons.person),
          onPressed: _cambiarNombre,
        ),
      ],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titulo,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contenido,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _guardar,
                    child: Text(_editando == null ? 'Guardar' : 'Actualizar'),
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
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _notas.isEmpty
              ? const Center(child: Text('No hay notas guardadas'))
              : ListView.builder(
                  itemCount: _notas.length,
                  itemBuilder: (_, i) {
                    final nota = _notas[i];
                    return ListTile(
                      leading: nota.pendienteSincronizar
                          ? const Icon(Icons.cloud_off)
                          : const Icon(Icons.cloud_done),
                      title: Text(nota.titulo),
                      subtitle: Text(
                        nota.contenido,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        tooltip: 'Eliminar',
                        icon: const Icon(Icons.delete),
                        onPressed: () => _eliminar(nota),
                      ),
                      onTap: () => _editar(nota),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
