import 'package:flutter/material.dart';

class FormularioTarea extends StatefulWidget {
  final String? tituloInicial;
  final String? descInicial;
  final Function(String titulo, String desc) onGuardar;

  const FormularioTarea({
    super.key,
    this.tituloInicial,
    this.descInicial,
    required this.onGuardar,
  });

  @override
  State<FormularioTarea> createState() => _FormularioTareaState();
}

class _FormularioTareaState extends State<FormularioTarea> {
  late TextEditingController _tituloCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController(text: widget.tituloInicial ?? '');
    _descCtrl = TextEditingController(text: widget.descInicial ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.tituloInicial == null ? 'Nueva Tarea' : 'Editar Tarea',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _tituloCtrl,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descCtrl,
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
          onPressed: () {
            final titulo = _tituloCtrl.text.trim();
            final desc = _descCtrl.text.trim();
            if (titulo.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('El título no puede estar vacío')),
              );
              return;
            }
            widget.onGuardar(titulo, desc);
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
