import 'package:flutter/material.dart';

import '../models/tarea.dart';

class FormularioTarea extends StatefulWidget {
  const FormularioTarea({
    super.key,
    required this.editando,
    required this.onGuardar,
    required this.onCancelar,
  });

  final Tarea? editando;
  final Future<String?> Function(String) onGuardar;
  final VoidCallback onCancelar;

  @override
  State<FormularioTarea> createState() => _FormularioTareaState();
}

class _FormularioTareaState extends State<FormularioTarea> {
  final _controlador = TextEditingController();
  String? _error;

  @override
  void didUpdateWidget(FormularioTarea anterior) {
    super.didUpdateWidget(anterior);
    if (anterior.editando?.id != widget.editando?.id) {
      _controlador.text = widget.editando?.titulo ?? '';
      _error = null;
    }
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final error = await widget.onGuardar(_controlador.text);
    if (!mounted) return;
    setState(() => _error = error);
    if (error == null) _controlador.clear();
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.editando != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          TextField(
            controller: _controlador,
            decoration: InputDecoration(
              labelText: editando ? 'Editar tarea' : 'Nueva tarea',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _enviar(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (editando)
                TextButton(
                  onPressed: () {
                    setState(() => _error = null);
                    widget.onCancelar();
                  },
                  child: const Text('Cancelar'),
                ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _enviar,
                child: Text(editando ? 'Actualizar' : 'Agregar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
