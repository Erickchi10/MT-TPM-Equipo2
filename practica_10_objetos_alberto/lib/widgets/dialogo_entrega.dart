import 'package:flutter/material.dart';

/// Pide el nombre de la persona a quien se entrega el objeto.
class DialogoEntrega extends StatefulWidget {
  const DialogoEntrega({super.key});

  @override
  State<DialogoEntrega> createState() => _DialogoEntregaState();
}

class _DialogoEntregaState extends State<DialogoEntrega> {
  final _form = GlobalKey<FormState>();
  final _nombre = TextEditingController();

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Entregar objeto'),
      content: Form(
        key: _form,
        child: TextFormField(
          controller: _nombre,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: '¿A quién se entrega?',
            hintText: 'Nombre del dueño',
          ),
          validator: (v) => (v?.trim().length ?? 0) < 3
              ? 'Escribe el nombre (mínimo 3 letras)'
              : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (_form.currentState!.validate()) {
              Navigator.pop(context, _nombre.text.trim());
            }
          },
          child: const Text('Entregar'),
        ),
      ],
    );
  }
}
