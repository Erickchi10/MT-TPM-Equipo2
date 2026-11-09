import 'package:flutter/material.dart';

class CampoNuevoHabito extends StatefulWidget {
  const CampoNuevoHabito({super.key, required this.onAgregar});

  final void Function(String) onAgregar;

  @override
  State<CampoNuevoHabito> createState() => _CampoNuevoHabitoState();
}

class _CampoNuevoHabitoState extends State<CampoNuevoHabito> {
  final _controlador = TextEditingController();

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _enviar() {
    widget.onAgregar(_controlador.text);
    _controlador.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controlador,
              decoration: const InputDecoration(
                labelText: 'Nuevo hábito',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _enviar(),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(onPressed: _enviar, child: const Text('Agregar')),
        ],
      ),
    );
  }
}
