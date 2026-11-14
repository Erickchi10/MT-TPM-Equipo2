import 'package:flutter/material.dart';

import '../database/db.dart';
import '../preferencias.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final _titulo = TextEditingController();
  final _contenido = TextEditingController();
  List<Map<String, dynamic>> _notas = [];
  int? _idEditando;
  String _nombre = 'Invitado';

  @override
  void initState() {
    super.initState();
    _cargarTodo();
  }

  @override
  void dispose() {
    _titulo.dispose();
    _contenido.dispose();
    super.dispose();
  }

  Future<void> _cargarTodo() async {
    final nombre = await leerNombre();
    final notas = await DB.listar();
    if (!mounted) return;
    setState(() {
      _nombre = nombre;
      _notas = notas;
    });
  }

  Future<void> _refrescar() async {
    final notas = await DB.listar();
    if (!mounted) return;
    setState(() => _notas = notas);
  }

  void _aviso(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _limpiar() {
    _titulo.clear();
    _contenido.clear();
    setState(() => _idEditando = null);
  }

  Future<void> _guardar() async {
    final titulo = _titulo.text.trim();
    final contenido = _contenido.text.trim();
    if (titulo.isEmpty) {
      _aviso('Escribe un título');
      return;
    }
    if (_idEditando == null) {
      await DB.insertar(titulo, contenido);
      _aviso('Nota guardada');
    } else {
      await DB.actualizar(_idEditando!, titulo, contenido);
      _aviso('Nota actualizada');
    }
    _limpiar();
    await _refrescar();
  }

  void _editar(Map<String, dynamic> nota) {
    setState(() {
      _idEditando = nota['id'] as int;
      _titulo.text = (nota['titulo'] ?? '') as String;
      _contenido.text = (nota['contenido'] ?? '') as String;
    });
  }

  Future<void> _confirmarEliminar(Map<String, dynamic> nota) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('¿Seguro que quieres eliminar "${nota['titulo']}"?'),
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
    if (confirmado != true) return;
    await DB.eliminar(nota['id'] as int);
    if (_idEditando == nota['id']) _limpiar();
    await _refrescar();
    _aviso('Nota eliminada');
  }

  Future<void> _cambiarNombre() async {
    final control = TextEditingController(
      text: _nombre == 'Invitado' ? '' : _nombre,
    );
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Cómo te llamas?'),
        content: TextField(
          controller: control,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, control.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (nuevo == null || nuevo.isEmpty) return;
    await guardarNombre(nuevo);
    if (!mounted) return;
    setState(() => _nombre = nuevo);
  }

  @override
  Widget build(BuildContext context) {
    final editando = _idEditando != null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $_nombre'),
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
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _titulo,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _contenido,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Contenido',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _guardar,
                        icon: Icon(editando ? Icons.edit : Icons.save),
                        label: Text(editando ? 'Actualizar' : 'Guardar'),
                      ),
                    ),
                    if (editando) ...[
                      const SizedBox(width: 8),
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
                ? const Center(child: Text('Sin notas todavía'))
                : ListView.builder(
                    itemCount: _notas.length,
                    itemBuilder: (context, i) {
                      final nota = _notas[i];
                      final pendiente =
                          (nota['pendiente_sincronizar'] as int? ?? 1) == 1;
                      return ListTile(
                        selected: nota['id'] == _idEditando,
                        leading: Icon(
                          pendiente ? Icons.cloud_off : Icons.cloud_done,
                          color: pendiente ? Colors.orange : Colors.green,
                        ),
                        title: Text('${nota['titulo']}'),
                        subtitle: Text(
                          '${nota['contenido'] ?? ''}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => _editar(nota),
                        trailing: IconButton(
                          tooltip: 'Eliminar',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _confirmarEliminar(nota),
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
