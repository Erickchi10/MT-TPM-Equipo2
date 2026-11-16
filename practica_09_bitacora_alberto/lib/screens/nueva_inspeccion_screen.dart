import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bitacora_provider.dart';

class NuevaInspeccionScreen extends StatefulWidget {
  const NuevaInspeccionScreen({super.key});

  @override
  State<NuevaInspeccionScreen> createState() => _NuevaInspeccionScreenState();
}

class _NuevaInspeccionScreenState extends State<NuevaInspeccionScreen> {
  final _form = GlobalKey<FormState>();
  final _titulo = TextEditingController();

  @override
  void dispose() {
    _titulo.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_form.currentState!.validate()) return;
    final r = await context.read<BitacoraProvider>().registrar(_titulo.text);
    if (!mounted) return;
    if (r.ok) {
      Navigator.pop(context, r.mensaje);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(r.mensaje)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final registrando = context.watch<BitacoraProvider>().registrando;
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva inspección')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titulo,
              maxLength: 40,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Área o equipo inspeccionado',
                hintText: 'Ej. Extintor del pasillo B',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Escribe qué se inspeccionó'
                  : null,
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Se registrará automáticamente'),
                subtitle: Text(
                  'La foto, la fecha y hora, y los valores del acelerómetro '
                  'y del giroscopio en ese momento.',
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: registrando ? null : _registrar,
              icon: registrando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.photo_camera),
              label: Text(
                registrando ? 'Registrando...' : 'Tomar foto y registrar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
