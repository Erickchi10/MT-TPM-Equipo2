import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lugares_provider.dart';
import '../services/coordenadas.dart';

class FormLugar extends StatefulWidget {
  const FormLugar({super.key});

  @override
  State<FormLugar> createState() => _FormLugarState();
}

class _FormLugarState extends State<FormLugar> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _coords = TextEditingController();
  bool _usarGps = true;
  bool _guardando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _coords.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final prov = context.read<LugaresProvider>();
    setState(() => _guardando = true);
    String? error;
    if (_usarGps) {
      error = await prov.agregarAqui(_nombre.text);
    } else {
      final c = Coordenadas.leer(_coords.text)!;
      error = await prov.agregar(_nombre.text, c.lat, c.lng);
    }
    if (!mounted) return;
    setState(() => _guardando = false);
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<LugaresProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo lugar')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombre,
              maxLength: 40,
              decoration: const InputDecoration(
                labelText: 'Nombre del lugar',
                hintText: 'Ej. ITESCAM, Parque, Mi casa',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Escribe un nombre' : null,
            ),
            const SizedBox(height: 8),
            const Text('¿Dónde está?'),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.my_location),
                  label: Text('Mi ubicación'),
                ),
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.edit_location_alt),
                  label: Text('Coordenadas'),
                ),
              ],
              selected: {_usarGps},
              onSelectionChanged: (s) => setState(() => _usarGps = s.first),
            ),
            const SizedBox(height: 16),
            if (_usarGps)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  prov.tieneUbicacion ? Icons.check_circle : Icons.info_outline,
                ),
                title: Text(
                  prov.tieneUbicacion
                      ? 'Se guardará tu ubicación actual'
                      : 'Primero toca "Mi ubicación" en la pantalla principal',
                ),
                subtitle: prov.tieneUbicacion
                    ? Text(
                        '${prov.resultado!.latitud!.toStringAsFixed(6)}, '
                        '${prov.resultado!.longitud!.toStringAsFixed(6)}',
                      )
                    : null,
              )
            else
              TextFormField(
                controller: _coords,
                decoration: const InputDecoration(
                  labelText: 'Latitud, longitud',
                  hintText: '20.370855, -90.050467',
                  helperText: 'En Google Maps deja presionado un lugar y copia las coordenadas',
                  helperMaxLines: 2,
                  border: OutlineInputBorder(),
                ),
                validator: (v) => Coordenadas.leer(v ?? '') == null
                    ? 'Formato: latitud, longitud (ej. 20.37, -90.05)'
                    : null,
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: const Icon(Icons.save),
              label: const Text('Guardar lugar'),
            ),
          ],
        ),
      ),
    );
  }
}
