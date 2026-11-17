import 'package:flutter/material.dart';

class DialogoNuevaTarea extends StatefulWidget {
  const DialogoNuevaTarea({super.key});

  @override
  State<DialogoNuevaTarea> createState() => _DialogoNuevaTareaState();
}

class _DialogoNuevaTareaState extends State<DialogoNuevaTarea> {
  final TextEditingController _controlador = TextEditingController();

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva tarea'),
      content: TextField(
        controller: _controlador,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Título'),
        onSubmitted: (valor) => Navigator.of(context).pop(valor),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controlador.text),
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
