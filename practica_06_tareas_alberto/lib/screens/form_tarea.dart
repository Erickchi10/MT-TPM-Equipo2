import 'package:flutter/material.dart';

import '../models/tarea.dart';

class FormTarea extends StatefulWidget {
  final Tarea? tarea;
  const FormTarea({super.key, this.tarea});

  @override
  State<FormTarea> createState() => _FormTareaState();
}

class _FormTareaState extends State<FormTarea> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _descripcion;
  late Prioridad _prioridad;
  late bool _completada;

  bool get _editando => widget.tarea != null;

  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(text: widget.tarea?.titulo ?? '');
    _descripcion = TextEditingController(text: widget.tarea?.descripcion ?? '');
    _prioridad = widget.tarea?.prioridad ?? Prioridad.media;
    _completada = widget.tarea?.completada ?? false;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    final base = widget.tarea;
    final tarea = base == null
        ? Tarea(
            titulo: _titulo.text.trim(),
            descripcion: _descripcion.text.trim(),
            prioridad: _prioridad,
            creada: DateTime.now(),
          )
        : base.copyWith(
            titulo: _titulo.text.trim(),
            descripcion: _descripcion.text.trim(),
            prioridad: _prioridad,
            completada: _completada,
          );
    Navigator.pop(context, tarea);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editando ? 'Editar tarea' : 'Nueva tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titulo,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Título *',
                border: OutlineInputBorder(),
              ),
              validator: Tarea.validarTitulo,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descripcion,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Prioridad'),
            const SizedBox(height: 8),
            SegmentedButton<Prioridad>(
              segments: [
                for (final p in Prioridad.values)
                  ButtonSegment(value: p, label: Text(p.etiqueta)),
              ],
              selected: {_prioridad},
              onSelectionChanged: (s) => setState(() => _prioridad = s.first),
            ),
            if (_editando)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Completada'),
                value: _completada,
                onChanged: (v) => setState(() => _completada = v),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
